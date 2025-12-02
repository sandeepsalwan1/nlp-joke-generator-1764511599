import os
import torch
from transformers import GPT2LMHeadModel, GPT2Tokenizer

def generate_joke(model, tokenizer, prompt, max_length=100):
    model.eval()
    input_text = f"{tokenizer.bos_token}{prompt}"
    input_ids = tokenizer.encode(input_text, return_tensors='pt')
    
    with torch.no_grad():
        output = model.generate(
            input_ids,
            max_length=max_length,
            temperature=0.8,
            top_k=50,
            top_p=0.95,
            do_sample=True,
            pad_token_id=tokenizer.pad_token_id,
            eos_token_id=tokenizer.eos_token_id,
            repetition_penalty=1.2,
            no_repeat_ngram_size=3
        )
    
    decoded = tokenizer.decode(output[0], skip_special_tokens=True)
    # Clean up prompt from output if duplicated
    if decoded.startswith(prompt):
        decoded = decoded[len(prompt):]
    return f"{prompt}{decoded}"

def main():
    model_path = "final_model_ready"
    
    print(f"Loading model from: {model_path}")
    if not os.path.exists(model_path):
        print("Error: Folder not found!")
        return

    try:
        tokenizer = GPT2Tokenizer.from_pretrained(model_path)
        model = GPT2LMHeadModel.from_pretrained(model_path)
    except Exception as e:
        print(f"Error loading model. Make sure you have 'transformers' and 'torch' installed.\nError: {e}")
        return

    prompts = [
        "Why did the chicken",
        "A man walks into a bar",
        "My wife told me",
        "What do you call a"
    ]

    print("\n" + "="*40)
    print("GENERATING JOKES FROM LOCAL MODEL")
    print("="*40)

    for prompt in prompts:
        joke = generate_joke(model, tokenizer, prompt)
        print(f"\nPrompt: {prompt}")
        print(f"Result: {joke.strip()}")
        print("-" * 20)

if __name__ == "__main__":
    main()






