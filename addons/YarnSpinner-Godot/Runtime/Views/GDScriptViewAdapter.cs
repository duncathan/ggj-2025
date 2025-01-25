using System;
using Godot;
using Yarn.Markup;

namespace YarnSpinnerGodot;

/// <summary>
/// Wrapper which allows you to implement a YarnSpinner DialogueViewBase via
/// GDScript by calling snake_case versions of each method. 
/// Add this script to a node for each GDScript view you want to implement,
/// then assign GDScriptView in the inspector to the node with your view script
/// written in GDScript. 
/// 
///
/// Note: You still have to use the version of Godot which supports C# in order to use
/// this plugin. 
/// </summary>
[GlobalClass]
public partial class GDScriptViewAdapter : Node, DialogueViewBase
{
    /// <summary>
    /// Assign this node to the node with the GDScript implementing your view attached.
    /// </summary>
    [Export] public Node GDScriptView;

    public Action requestInterrupt { get; set; }

    /// <inheritdoc/>
    /// Implement a GDScript method dialogue_started() -> void 
    public void DialogueStarted()
    {
        if (!IsInstanceValid(GDScriptView))
        {
            return;
        }

        const string gdScriptName = "dialogue_started";
        if (GDScriptView.HasMethod(gdScriptName))
        {
            GDScriptView.Call(gdScriptName);
        }
    }

    /// <inheritdoc/>
    /// Implement a GDScript method run_line(line: dict, on_dialogue_line_finished: Callable) -> void
    public void RunLine(LocalizedLine dialogueLine, Action onDialogueLineFinished)
    {
        if (!IsInstanceValid(GDScriptView))
        {
            return;
        }

        const string gdScriptName = "run_line";
        if (!GDScriptView.HasMethod(gdScriptName))
        {
            // The default implementation does nothing, and immediately calls
            // onDialogueLineFinished.
            onDialogueLineFinished?.Invoke();
        }
        else
        {
            GDScriptView.Call(gdScriptName, LocalizedLineToDict(dialogueLine),
                Callable.From(onDialogueLineFinished));
        }
    }

    /// <summary>
    /// Convert a LocalizedLine to a Godot Dictionary that is more accessible from GDScript. 
    /// 	# example: 
    ///  {"metadata":["my_metadata"],
    ///  "text":
    ///      {
    ///        "attributes":[
    ///            { "length":8,"name":"fx","position":20,"properties":[{"type":"wave"}]},
    ///         	{ "length":6,"name":"character","position":0,"properties":[{"name":"Gary"}]}
    ///      ],
    ///      "text":"Gary: So, can I use GDScript with YarnSpinner?",
    ///      "text_without_character_name":"So, can I use GDScript with YarnSpinner?"
    ///   }
    ///  }
    /// </summary>
    /// <param name="dialogueLine"></param>
    /// <returns></returns>
    public static Godot.Collections.Dictionary LocalizedLineToDict(LocalizedLine dialogueLine)
    {
        var dialogueLineDict = new Godot.Collections.Dictionary();
        var metadataArray = new Godot.Collections.Array();
        metadataArray.AddRange(dialogueLine.Metadata ?? Array.Empty<string>());
        dialogueLineDict["metadata"] = metadataArray;

        var textDict = new Godot.Collections.Dictionary();
        textDict["text"] = dialogueLine.Text.Text;
        textDict["text_without_character_name"] = dialogueLine.TextWithoutCharacterName.Text;
        var attributesList = new Godot.Collections.Array();
        foreach (var attribute in dialogueLine.Text.Attributes)
        {
            var attributeDict = new Godot.Collections.Dictionary();
            attributeDict["name"] = attribute.Name;
            attributeDict["length"] = attribute.Length;
            attributeDict["position"] = attribute.Position;
            var propertiesList = new Godot.Collections.Array();
            foreach (var property in attribute.Properties)
            {
                var propertyDict = new Godot.Collections.Dictionary();
                var castValue = property.Value.Type switch
                {
                    MarkupValueType.Integer => Variant.From(property.Value.IntegerValue),
                    MarkupValueType.Float => Variant.From(property.Value.FloatValue),
                    MarkupValueType.String => Variant.From(property.Value.StringValue),
                    MarkupValueType.Bool => Variant.From(property.Value.BoolValue),
                    _ => new Variant(),
                };

                propertyDict[property.Key] = castValue;
                propertiesList.Add(propertyDict);
            }

            attributeDict["properties"] = propertiesList;
            attributesList.Add(attributeDict);
        }

        textDict["attributes"] = attributesList;
        dialogueLineDict["text"] = textDict;
        return dialogueLineDict;
    }

    /// <inheritdoc/>
    /// Implement a GDScript method interrupt_line(line: dict, on_dialogue_line_finished: Callable) 
    public void InterruptLine(LocalizedLine dialogueLine, Action onDialogueLineFinished)
    {
        if (!IsInstanceValid(GDScriptView))
        {
            return;
        }

        const string gdScriptName = "interrupt_line";
        if (!GDScriptView.HasMethod(gdScriptName))
        {
            // the default implementation does nothing
            onDialogueLineFinished?.Invoke();
        }
        else
        {
            GDScriptView.Call(gdScriptName, LocalizedLineToDict(dialogueLine),
                Callable.From(onDialogueLineFinished));
        }
    }

    /// <inheritdoc/>
    /// Implement a GDScript method dismiss_line(on_dismissal_complete: Callable) -> void 
    public void DismissLine(Action onDismissalComplete)
    {
        if (!IsInstanceValid(GDScriptView))
        {
            return;
        }

        const string gdScriptName = "dismiss_line";
        if (!GDScriptView.HasMethod(gdScriptName))
        {
            // The default implementation does nothing, and immediately calls
            // onDialogueLineFinished.
            onDismissalComplete?.Invoke();
        }
        else
        {
            GDScriptView.Call(gdScriptName, Callable.From(onDismissalComplete));
        }
    }

    /// <inheritdoc/>
    /// Implement a GDScript method run_options(options: Array, on_option_selected: Callable (single int parameter)) -> void 
    public void RunOptions(DialogueOption[] dialogueOptions,
        Action<int> onOptionSelected)
    {
        if (!IsInstanceValid(GDScriptView))
        {
            return;
        }

        const string gdScriptName = "run_options";
        if (!GDScriptView.HasMethod(gdScriptName))
        {
            return;
        }

        var dialogueOptionsList = new Godot.Collections.Array();
        foreach (var option in dialogueOptions)
        {
            var optionDict = new Godot.Collections.Dictionary();
            optionDict["dialogue_option_id"] = option.DialogueOptionID;
            optionDict["text_id"] = option.TextID;
            optionDict["line"] = LocalizedLineToDict(option.Line);
            optionDict["is_available"] = option.IsAvailable;
            dialogueOptionsList.Add(optionDict);
        }

        GDScriptView.Call(gdScriptName, dialogueOptionsList, Callable.From(onOptionSelected));
    }

    /// <inheritdoc/>
    /// Implement a GDScript method dialogue_complete() -> void
    public void DialogueComplete()
    {
        if (!IsInstanceValid(GDScriptView))
        {
            return;
        }

        const string gdScriptName = "dialogue_complete";
        if (GDScriptView.HasMethod(gdScriptName))
        {
            GDScriptView.Call(gdScriptName);
        }
    }

    /// <inheritdoc/>
    /// Implement a GDScript method user_requested_view_advancement() -> void 
    public void UserRequestedViewAdvancement()
    {
        if (!IsInstanceValid(GDScriptView))
        {
            return;
        }

        const string gdScriptName = "user_requested_view_advancement";
        if (GDScriptView.HasMethod(gdScriptName))
        {
            GDScriptView.Call(gdScriptName);
        }
    }
}