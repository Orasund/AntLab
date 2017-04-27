/**
 * Template interactor between a TemplateBeing and another TemplateBeing
 * Don't forget to change TemplateBeing-s to
 * the names of the Being-types you want to interact
 */
class TemplateInteractor extends Interactor<Square, Square>
{
  TemplateInteractor()
  {
    super();
    //Add your constructor info here
  }

  boolean detect(Square being1, Square being2)
  {
    //Add your detect method here
    return true;
  }

  void handle(Square being1, Square being2)
  {
    //Add your handle method here
  }
}