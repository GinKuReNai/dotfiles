require("CopilotChat").setup {
    debug = true,
    system_prompt = "あなたは優秀なソフトウェアエンジニアです。日本語で回答してください。あなたの力を限界まで発揮してください。あなたならできます。",

    window = {
        layout = 'float',
        border = 'double',
        width = 0.8,
        height = 0.8,
    },

    model = 'gpt-4',
}
