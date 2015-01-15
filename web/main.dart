// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:stagexl/stagexl.dart';

Future<Map> loadSprite(String basename, int frame_x, int frame_y) {
  // TODO: get dims from sprite map?
  
  var resourceManager = new ResourceManager()
    ..addBitmapData("image", "assets/sprites/${basename}.png")
    ..addTextFile("map", "assets/sprites/${basename}.map.json");
  
  return resourceManager.load().then((_) {
    Map outMap = new Map();

    SpriteSheet source = new SpriteSheet(resourceManager.getBitmapData("image"), frame_x, frame_y);
    Map sourceMap = JSON.decode(resourceManager.getTextFile("map"));

    sourceMap.forEach((key, anim) {
      outMap[key] = {
        "frames": new List<BitmapData>(),
        "fps": anim["fps"],
      };
      
      for (int i = anim["first"]; i <= anim["last"]; i++) {
        outMap[key]["frames"].add(source.frameAt(i));
      };
    });
    
    return outMap;
  });
}

void main() {
  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  loadSprite('char0001_main', 64, 64).then((heroAnims) {
    var walk_east_anim = new FlipBook(heroAnims["walk_0"]["frames"], heroAnims["walk_0"]["fps"])
      ..x = 100
      ..y = 100
      ..addTo(stage)
      ..play();
    
    var walk_west_anim = new FlipBook(heroAnims["walk_180"]["frames"], heroAnims["walk_180"]["fps"])
      ..x = 200
      ..y = 100
      ..addTo(stage)
      ..play();
    
    stage.juggler
      ..add(walk_east_anim)
      ..add(walk_west_anim);
  });  
}