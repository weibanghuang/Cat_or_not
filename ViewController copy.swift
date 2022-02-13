//
//  ViewController.swift
//  CatOrNot
//
//  Created by WeiBang Huang on 12/5/21.
//

import UIKit
import AVKit
import Vision
import Foundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
//    private var label: UILabel = {
//        let label = UILabel()
//        label.text = "Select Image"
//        label.numberOfLines = 1
//        return label
//       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let labelRect = CGRect(x: (self.view.frame.width/2) - 10, y: self.view.frame.height , width: 300, height: 100)
        let label = UILabel(frame: labelRect)
        label.text = "Select Image"
        view.addSubview(label)
        
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.addSublayer(previewLayer)
        
        previewLayer.frame = view.frame
        
//        VNImageRequestHandler(cgImage:CGImage, options:[:]).perform(requests: [VNRequest])
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
       
        //count bottom count top
        
//        
//        var W3 = [[String]](repeating: [String](repeating: "", count: 1), count: 20)
//
//        guard let filepath = Bundle.main.path(forResource: "b1", ofType: "csv") else {
//            return
//        }
//        var data = ""
//        do {
//            data = try String(contentsOfFile: filepath)
//        } catch {
//            print(error)
//            return
//        }
//        let rows = data.components(separatedBy: "\n")
//        var i = 0 //top
//        var j = 0 //bottom
//        for row in rows {
//            if (i<20){
//                let columns = row.components(separatedBy: ",")
//                if (j<1){
//                    for x in columns{
//                        let a = x.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range: nil)
//                        W3[i][j] = a
//                        j+=1
//                    }
//                }
//                j=0
//                i+=1
//            }
//        }
//        let W3_double = W3.map { $0.compactMap(Double.init) }
//        let userDefaults = UserDefaults.standard
//
//        // Create and Write Array of Strings
//
//        userDefaults.set(W3_double, forKey: "b1")
//
//        let array1 = userDefaults.array(forKey: "b1")  as? [[Double]] ?? [[Double]]()
//
//        print(array1)
      
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection, result_text: String) {

//        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer)
        let image = self.convert(cmage: ciimage)
        let image1 = self.cropToBounds(image: image, width: 64.0, height: 64.0)
        let image2 = self.resizeImage(image: image1, targetSize: CGSize(width: 64.0, height: 64.0))
//        let data = image1.pngData()
        
//        let imageSaver = ImageSaver()
//        imageSaver.writeToPhotoAlbum(image: image2)
        
//        for index in 0...5 {
//            print("\(index) times 5 is \(index * 5)")
//        }
    
//        if let (r,g,b,a) = pixel(in: image2, at: CGPoint(x: 1, y:2)) {
//            print ("Red: \(r), Green: \(g), Blue: \(b), Alpha: \(a)")
//        }
        
        
        
        let userDefaults = UserDefaults.standard
        
        let W1 = userDefaults.array(forKey: "W1")  as? [[Double]] ?? [[Double]]()
        let b1 = userDefaults.array(forKey: "b1")  as? [[Double]] ?? [[Double]]()
        let W2 = userDefaults.array(forKey: "W2")  as? [[Double]] ?? [[Double]]()
        let b2 = userDefaults.array(forKey: "b2")  as? [[Double]] ?? [[Double]]()
        let W3 = userDefaults.array(forKey: "W3")  as? [[Double]] ?? [[Double]]()
        let b3 = userDefaults.array(forKey: "b3")  as? [[Double]] ?? [[Double]]()
        let W4 = userDefaults.array(forKey: "W4")  as? [[Double]] ?? [[Double]]()
        let b4 = userDefaults.array(forKey: "b4")  as? [[Double]] ?? [[Double]]()

        
        //CAT ARRAY
        var arr = [Double](repeating: 0, count: 12288)
        for j in 0...63{
            for i in 0...63{
                if let (r,g,b,a) = pixel(in: image2, at: CGPoint(x: i, y:j)) {
                    arr[(j*64)+i] = Double(r)/255
                    arr[(j*64)+i+4096] = Double(g)/255
                    arr[(j*64)+i+4096+4096] = Double(b)/255
                }
            }
        }
       
        var Z1 = [[Double]](repeating: [Double](repeating: 0, count: 1), count: 20)
        var Z2 = [[Double]](repeating: [Double](repeating: 0, count: 1), count: 7)
        var Z3 = [[Double]](repeating: [Double](repeating: 0, count: 1), count: 5)
        var Z4 = [[Double]](repeating: [Double](repeating: 0, count: 1), count: 1)

        //Z1
        for i in 0...19{
            for j in 0...12287{
                Z1[i][0] += (arr[j]*W1[i][j])
            }
            Z1[i][0] += b1[i][0]
            Z1[i][0] = RELU(number: Z1[i][0])
        }

        //Z2
        for i in 0...6{
            for j in 0...19{
                Z2[i][0] += (Z1[j][0]*W2[i][j])
            }
            Z2[i][0] += b2[i][0]
            Z2[i][0] = RELU(number: Z2[i][0])
        }
        
        //Z3
        for i in 0...4{
            for j in 0...6{
                Z3[i][0] += (Z2[j][0]*W3[i][j])
            }
            Z3[i][0] += b3[i][0]
            Z3[i][0] = RELU(number: Z3[i][0])
        }
       
        //Z4
        for i in 0...0{
            for j in 0...4{
                Z4[i][0] += (Z3[j][0]*W4[i][j])
            }
            Z4[i][0] += b4[i][0]

            Z4[i][0] = SIGMOID(number: Z4[i][0])


        }

//        if(Z4[0][0]>0.5){
//            label.text = "CAT"
//        }else{
//            label.text = "NOT CAT"
//        }
//        print(Z4[0][0])
        
        
    }
    
    func convert(cmage: CIImage) -> UIImage {
         let context = CIContext(options: nil)
         let cgImage = context.createCGImage(cmage, from: cmage.extent)!
         let image = UIImage(cgImage: cgImage)
         return image
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

            let cgimage = image.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!

            // Create a new image based on the imageRef and rotate back to the original orientation
            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

            return image
        }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        var newSize: CGSize
        newSize = CGSize(width: targetSize.width, height: targetSize.height)


        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
  
    func pixel(in image: UIImage, at point: CGPoint) -> (UInt8, UInt8, UInt8, UInt8)? {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let x = Int(point.x)
        let y = Int(point.y)
        guard x < width && y < height else {
            return nil
        }
        guard let cfData:CFData = image.cgImage?.dataProvider?.data, let pointer = CFDataGetBytePtr(cfData) else {
            return nil
        }
        let bytesPerPixel = 4
        let offset = (x + y * width) * bytesPerPixel
        return (pointer[offset], pointer[offset + 1], pointer[offset + 2], pointer[offset + 3])
    }
    
    func RELU(number: Double) ->Double{
        if (number>0){
            return number
        }else{
            return 0
        }
        
    }
    
    func SIGMOID(number: Double) ->Double{
        return 1/(1+(pow(2.71828182846, -1*number)))
    }
    

    
}

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
