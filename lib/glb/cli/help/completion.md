## Examples

    glb completion

Prints words for TAB auto-completion.

    glb completion
    glb completion hello
    glb completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(glb completion_script)

Auto-completion example usage:

    glb [TAB]
    glb hello [TAB]
    glb hello name [TAB]
    glb hello name --[TAB]
