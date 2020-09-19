using Godot;
using System;

public class Game : Node
{
    [Export]
    public Resource gameState
    {
        get { return gameState; }
        set
        {
            gameState = value;
            gameState.Connect("turn_added", this, "OnGameStateTurnAdded");
            gameState.Connect("turn_erased", this, "OnGameStateTurnErased");
            gameState.Connect("turn_part_added", this, "OnGameStateTurnPartAdded");
            gameState.Connect("turn_part_erased", this, "OnGameStateTurnPartErased");
        }
    }

    [Export]
    public Godot.Collections.Array<Resource> executionQueue;

    [Export]
    public Godot.Collections.Array<Resource> executionStack;

    private bool _is_last_modifier_executed = true;


    public override void _Process(float delta)
    {
        TryExecuteQueueTopModifier();
    }

    private void TryExecuteQueueTopModifier()
    {
        if (executionQueue.Count > 0)
        {
            Resource modifier = executionQueue[executionQueue.Count];
            executionQueue.RemoveAt(executionQueue.Count);
        }
    }

    private void TryExecuteModifier(Resource modifier)
    {
        if(_is_last_modifier_executed) {
            _is_last_modifier_executed = false;
            modifier.Connect("just_executed", this, "OnModifierJustExecuted");
            modifier.Execute(this);
        }
    }

    protected virtual void OnGameStateTurnAdded() { }

    protected virtual void OnGameStateTurnErased() { }

    protected virtual void OnGameStateTurnPartAdded() { }

    protected virtual void OnGameStateTurnPartErased() { }
}
