# Chat with an intelligent assistant in your terminal
from openai import OpenAI

# Point to the local server
client = OpenAI(base_url="http://192.168.0.21:1234/v1", api_key="not-needed")

history = [
    {"role": "system", "content": "Tu es un assistante intelligente. Tu fournis toujours des réponses bien fondées qui sont à la fois justes et utiles."},
    {"role": "user", "content": "Salut, Présentez-vous à quelqu'un ouvrant ce programme pour la première fois. Sois concis."},
]
stop = False
while True:
    if stop:
        break
    completion = client.chat.completions.create(
        model="local-model", # this field is currently unused
        messages=history,
        temperature=0.7,
        stream=True,
    )

    new_message = {"role": "assistant", "content": ""}

    for chunk in completion:
        if chunk.choices[0].delta.content:
            print(chunk.choices[0].delta.content, end="", flush=True)
            new_message["content"] += chunk.choices[0].delta.content

    history.append(new_message)
    for i, t in enumerate(history):
        if (history[i].get("content").capitalize()) == "Exit":
            stop = True

    # Uncomment to see chat history
    # import json
    # gray_color = "\033[90m"
    # reset_color = "\033[0m"
    # print(f"{gray_color}\n{'-'*20} History dump {'-'*20}\n")
    # print(json.dumps(history, indent=2))
    # print(f"\n{'-'*55}\n{reset_color}")

    print()
    if not stop:
        history.append({"role": "user", "content": input("> ")})
