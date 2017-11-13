CKEDITOR.plugins.add( 'markups',
{
  init: function( editor ){

    var addTagCommand = function(buttonName, buttonLabel, commandName, styleClass){
      var style = new CKEDITOR.style({element: 'span', attributes: {'class': styleClass}});
      editor.attachStyleStateChange( style, function( state ) {
        !editor.readOnly && editor.getCommand( commandName ).setState( state );
      });
      editor.addCommand(commandName, new CKEDITOR.styleCommand( style ));
      editor.ui.addButton(buttonName,
        {
          label: buttonLabel,
          command: commandName
        });
    }
    addTagCommand('Fachtermini', 'Fachtermini', 'markFachtermini', 'fachtermini');
    addTagCommand('Werktitel original', 'Werktitel original', 'markWerktitel_original', 'werktitel_original');
    addTagCommand('Werktitel fremdspr', 'Werktitel fremdspr', 'markWerktitel_fremdspr', 'werktitel_fremdspr');
    addTagCommand('Sonstiges', 'Sonstiges', 'markSonstiges', 'sonstiges');
    addTagCommand('Eigennamen', 'Eigennamen', 'markEigennamen', 'eigennamen');
    addTagCommand('fragliche Stellen', 'fragliche Stellen', 'markFragliche_Stellen', 'fragliche_stellen');
    addTagCommand('Indexeintrag', 'Indexeintrag', 'markIndexeintrag', 'indexeintrag');
  }

} );
