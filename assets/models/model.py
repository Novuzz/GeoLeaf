# ...existing code...
import torch
import torch.nn as nn
from torch.utils.mobile_optimizer import optimize_for_mobile
import torchvision.models as models # Example: using a standard model

# 1. Define or load your original model architecture
# This example uses a pretrained MobileNetV2, replace with your model definition
model = models.mobilenet_v2(pretrained=True)
model.eval()  # Set to evaluation mode

# If you only have a .pth file of weights, load them first:
ckpt_path = 'model_mobilenetv2.pth'
ckpt = torch.load(ckpt_path, map_location='cpu')

# Support both plain state_dict and wrapped dicts like {'state_dict': ...}
state_dict = None
if isinstance(ckpt, dict):
    # common keys: 'state_dict' or plain state_dict saved directly
    if 'state_dict' in ckpt:
        state_dict = ckpt['state_dict']
    else:
        # assume it's already a state_dict
        state_dict = ckpt
else:
    state_dict = ckpt

# Determine classifier output size from checkpoint if present
out_features = None
# MobileNetV2 classifier layer key is typically 'classifier.1.weight'
for k, v in state_dict.items():
    if k.endswith('classifier.1.weight'):
        out_features = v.size(0)
        break
    if k.endswith('classifier.weight') and 'classifier' in k:  # fallback
        out_features = v.size(0)
        break

# If sizes differ, replace model.classifier to match checkpoint
if out_features is not None:
    cur_out = model.classifier[1].out_features
    if cur_out != out_features:
        # MobileNetV2 classifier is: Sequential(Dropout, Linear(1280, num_classes))
        in_features = model.classifier[1].in_features
        model.classifier = nn.Sequential(
            nn.Dropout(p=0.2, inplace=False),
            nn.Linear(in_features, out_features)
        )
        print(f"Replaced model.classifier to output {out_features} classes (was {cur_out}).")

# Now load weights (strict=True will ensure shapes match; change to False if you want to skip missing keys)
model.load_state_dict(state_dict, strict=True)

# 2. Trace or script the model
# JIT scripting converts Python code to a static graph
scripted_module = torch.jit.script(model)

# 3. Optimize the scripted module for mobile (this creates the bytecode/data internally)
optimized_scripted_module = optimize_for_mobile(scripted_module)

# 4. Save the final optimized model file
# The .ptl extension is recommended for the lite interpreter
optimized_scripted_module._save_for_lite_interpreter("my_optimized_model.ptl")
# ...existing code...