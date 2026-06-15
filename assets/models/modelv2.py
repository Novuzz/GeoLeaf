import torch
import torchvision.models as models
import onnx
from onnx_tf.backend import prepare
import tensorflow as tf

def convert():
    print("Step 1: Loading PyTorch Model...")
    # Standard torchvision model used as an example
    # If using your own weights, modify to: model.load_state_dict(torch.load("your_file.pth"))
    model = models.mobilenet_v2(weights=models.MobileNetV2_Weights.DEFAULT)
    model.eval()

    print("Step 2: Exporting to ONNX format...")
    # Create dummy input mimicking: (Batch, Channels, Height, Width)
    dummy_input = torch.randn(1, 3, 224, 224)
    
    torch.onnx.export(
        model, 
        dummy_input, 
        "model.onnx", 
        input_names=['input'], 
        output_names=['output'],
        opset_version=12
    )

    print("Step 3: Translating ONNX to TensorFlow Graph...")
    onnx_model = onnx.load("model.onnx")
    tf_rep = prepare(onnx_model)
    tf_rep.export_graph("./tf_model_folder")

    print("Step 4: Compiling TensorFlow to TFLite...")
    converter = tf.lite.TFLiteConverter.from_saved_model("./tf_model_folder")
    tflite_model = converter.convert()

    print("Step 5: Saving your .tflite file...")
    with open("mobilenet_v2.tflite", "wb") as f:
        f.write(tflite_model)

    print("\n🎉 Success! 'mobilenet_v2.tflite' is ready for your Flutter assets folder.")

if __name__ == "__main__":
    convert()