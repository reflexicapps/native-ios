/* @license
 * This file is part of the Game Closure SDK.
 *
 * The Game Closure SDK is free software: you can redistribute it and/or modify
 * it under the terms of the Mozilla Public License v. 2.0 as published by Mozilla.
 
 * The Game Closure SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * Mozilla Public License v. 2.0 for more details.
 
 * You should have received a copy of the Mozilla Public License v. 2.0
 * along with the Game Closure SDK.	 If not, see <http://mozilla.org/MPL/2.0/>.
 */

#import "jsTimestep.h"
#import "js_core.h"
#import "jsMacros.h"
#include "timestep_events.h"
#include "gen/js_animate_template.gen.h"
#include "gen/js_timestep_view_template.gen.h"
#include "gen/js_timestep_image_map_template.gen.h"
#include "js/js_timestep_view.h"



using namespace JS;

static JSObject *evt_ctor = NULL;

static JSBool defGetEvents(JSContext *cx, unsigned argc, jsval *vp) {
    JS_BeginRequest(cx);
    
    input_event_list events = timestep_events_get();
    int len = events.count;
    
    //
    //Get handle of InputEvent JS object contructor
    //
    jsval thiz_val = JS_THIS(cx, vp);
    JSObject *thiz = JSVAL_TO_OBJECT(thiz_val);
    
    if (!evt_ctor)
    {
    	JS::RootedValue ctor_val(cx); //WARNING: Try JS_RootedValue if fails
        JS_GetProperty(cx, thiz, "InputEvent", &ctor_val);
        if (!JSVAL_IS_PRIMITIVE(ctor_val)) {
            JSObject *ctor_obj = JSVAL_TO_OBJECT(ctor_val);
            if (ctor_obj && JS_ObjectIsFunction(cx, ctor_obj)) {
                evt_ctor = ctor_obj;
                JS_AddObjectRoot(cx, &evt_ctor);
            }
        }
    }
    
    jsval arr_val;
    jsval eventsLenVal;
    jsval targetEventVal;
    jsval x, y, type, id;
    jsval initMethodVal;
    jsval tmpVal;
    
    jsval argv[4];
    
    JS_GetProperty(cx, thiz, "GlobalInputEventsList", &arr_val);
    
    JSObject *arr = JSVAL_TO_OBJECT(arr_val);
    
    JS_ASSERT(evt_ctor != NULL);
    
    
    for (int i = 0; i < len; i++)
    {
        input_event evt = events.events[i];
        
        
        x = INT_TO_JSVAL(evt.x);
        y = INT_TO_JSVAL(evt.y);
        type = INT_TO_JSVAL(evt.type);
        id = INT_TO_JSVAL(evt.id);
        
        JS_GetElement(cx, arr, i, &targetEventVal);
        JSObject *targetEvent = JSVAL_TO_OBJECT(targetEventVal);
        
        if( i == 0 )
        {
            JS_GetProperty(cx, targetEvent, "init", &initMethodVal);
        }
        
        argv[0] = id;
        argv[1] = type;
        argv[2] = x;
        argv[3] = y;
        
        JS_CallFunctionName(cx, targetEvent, "init", 4,argv, &tmpVal);
    }
    
    jsval lenVal = INT_TO_JSVAL(len);
    JS_SetProperty(cx, thiz, "GlobalInputEventsListLen", &lenVal);
    
    JS_SET_RVAL(cx, vp, OBJECT_TO_JSVAL(arr));
    
    JS_EndRequest(cx);
    return JS_TRUE;
}

static const JSFunctionSpec functionSpec[] = {
    JS_FN("getEvents",				defGetEvents,				0, FUNCTION_FLAGS),
    JS_FN("setImageOnImageView",	def_image_view_set_image,	3, FUNCTION_FLAGS),
    JS_FS_END
};


@implementation jsTimestep

+ (void) addToRuntime:(js_core *)js {
    JSObject *timestep = JS_NewObject(js.cx, NULL, NULL, NULL);
    JS_DefineProperty(js.cx, js.native, "timestep", OBJECT_TO_JSVAL(timestep), NULL, NULL, PROPERTY_FLAGS);
    JS_DefineFunctions(js.cx, timestep, (JSFunctionSpec*)functionSpec);
    
    timestep_view_add_to_object(timestep);
    timestep_image_map_add_to_object(timestep);
    animate_add_to_object(timestep);
}

+ (void) onDestroyRuntime {
    evt_ctor = NULL;
}

@end
