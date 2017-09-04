//
//  ViewController.swift
//  ARKit初体验
//
//  Created by 陈万兵 on 2017/9/1.
//  Copyright © 2017年 陈万兵. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    //用来展示3D模型的视图
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        //设置3D场景视图的的代理
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //显示统计数据 如fps
        sceneView.showsStatistics = true
        
        // Create a new scene
        //创建一个场景 named: "art.scnassets/ship.scn" 读取一个模型
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //设置全局追踪
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        //启动追踪
        sceneView.session.run(configuration)
        
        
        //创建一个手势
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.creatImageNodeWithTap(tapGesture:)))
        
    
        view.addGestureRecognizer(tapGesture)
    }


    /// 实现 : 对飞机模型的AR场景 进行截图 在增强现实的场景中创建多个节点(模型) 在虚拟世界中万物皆模型
    ///
    /// - Parameter tapGesture: 手势
    @objc func creatImageNodeWithTap(tapGesture:UITapGestureRecognizer) -> () {
        /*
         实现 : 对飞机模型的AR场景 进行截图 在增强现实的场景中创建多个节点(模型) 在虚拟世界中万物皆模型
         1.判断能不能获取到当前的Frame
         2.创建一张截图
         3.对创建的图片进行截图
         4.通过截图创建一个节点并加到AR场景的根节点上
         4.追踪相机的位置
         
         */
        //守护  如果满足条件就往下执行 否则执行 return语句
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        
        //        創建一張圖片
        //SCNPlane
        
        //  A rectangular, one-sided plane geometry of specified width and height.   API
        //翻译 SCNPlane创建的对象是一个有指定宽高的平面矩形
        let imagePlane = SCNPlane(width: sceneView.bounds.width / 8000, height: sceneView.bounds.height / 8000)
        //        渲染圖片
        /*
         SCNMaterial 渲染
         API  A set of shading attributes that define the appearance of a geometry's surface when rendered.
         
         翻译  用来定义 几何表面被渲染时候的阴影属性
         firstMaterial 获取几何上的第一个材质
         diffuse
         Specifies the receiver's diffuse property
         diffuse 接收特定的属性
         
         */
        // 在创建的图片平面上截屏
        /*
         lightingModel  环境的光感变量 (以下来自百度翻译和自己的理解 不足及错误之处请指正)

         blinn:
         Shading that incorporates ambient, diffuse, and specular properties, where specular highlights are calculated using the Blinn-Phong formula.

         阴影包含三个要素 ： 环境 漫射 和 镜面 blinn属性是用Blinn-Phong公式计算的高光效果
         constant:
         Uniform shading that incorporates ambient lighting only.
         均匀的环境  只包含了光线

         lambert:
         Shading that incorporates ambient and diffuse properties only.
         仅包含环境属性和漫射属性

         phong:

         Shading that incorporates ambient, diffuse, and specular properties, where specular highlights are calculated using the Phong formula.
         明暗结合环境，扩散，和镜面反射特性，在高光使用Phong公式计算
         physicallyBased:
         Shading based on a realistic abstraction of physical lights and materials.
         基于物理光线和材质的真实抽象的阴影。
         */
        imagePlane.firstMaterial?.diffuse.contents = sceneView.snapshot()
        imagePlane.firstMaterial?.lightingModel = .constant
        
        //   在图片的几何平面上創建一個節點
        let planNode = SCNNode(geometry: imagePlane)
        //把该节点添加到AR场景的根节点上
        sceneView.scene.rootNode.addChildNode(planNode)
        
        //      追蹤相機的位置 （参考z轴）
        /*
         4X4的矩阵
         matrix_identity_float4x4
         columns.3.z  3代表3轴 xyz
         */
        var translate = matrix_identity_float4x4
        //在z轴的-0.1米的方向  在面前能显示  正数的话显示在后脑勺
        translate.columns.3.z = -0.1
        //      追蹤相機的位置
        //把截图显示在相机的前方10公分处
        planNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translate)
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session

        //暂停追踪
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()

     return node
     }
     */
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
