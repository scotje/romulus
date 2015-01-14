// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:stagexl/stagexl.dart';

void main() {
  var resourceManager = new ResourceManager()
    ..addBitmapData("hero", "assets/sprites/char0001_main.png")
    ..addTextFile("hero_map", "assets/sprites/char0001_main.map.json");
  
  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  resourceManager.load().then((_) {
    var hero = new SpriteSheet(resourceManager.getBitmapData("hero"), 64, 64);
    Map heroMap = JSON.decode(resourceManager.getTextFile("hero_map"));
    
    List<BitmapData> walk_east = (new List.from(heroMap["walk"]["e"])).map((frame_index) => hero.frameAt(frame_index)).toList();
    List<BitmapData> walk_west = (new List.from(heroMap["walk"]["w"])).map((frame_index) => hero.frameAt(frame_index)).toList();

    var walk_east_anim = new FlipBook(walk_east, 15)
      ..x = 100
      ..y = 100
      ..addTo(stage)
      ..play();
    
    var walk_west_anim = new FlipBook(walk_west, 15)
      ..x = 200
      ..y = 100
      ..addTo(stage)
      ..play();
    
    stage.juggler
      ..add(walk_east_anim)
      ..add(walk_west_anim);
  });
}