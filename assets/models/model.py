import torch
from torch.utils.mobile_optimizer import optimize_for_mobile
import torchvision.models as models # Example: using a standard model

# 1. Define or load your original model architecture
# This example uses a pretrained MobileNetV2, replace with your model definition
model = models.mobilenet_v2(pretrained=True) 
model.eval() # Set to evaluation mode

# If you only have a .pth file of weights, load them first:
# model.load_state_dict(torch.load('your_weights.pth'))

# 2. Trace or script the model
# JIT scripting converts Python code to a static graph
scripted_module = torch.jit.script(model)

# 3. Optimize the scripted module for mobile (this creates the bytecode/data internally)
optimized_scripted_module = optimize_for_mobile(scripted_module)

# 4. Save the final optimized model file
# The .ptl extension is recommended for the lite interpreter
optimized_scripted_module._save_for_lite_interpreter("my_optimized_model.ptl")
