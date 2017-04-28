/**
 * Template interactor between a TemplateBeing and another TemplateBeing
 * Don't forget to change TemplateBeing-s to
 * the names of the Being-types you want to interact
 */
class TemplateInteractor extends Interactor<Ant, Ant>
{
  TemplateInteractor()
  {
    super();
    //Add your constructor info here
  }

  boolean detect(Ant being1, Ant being2)
  {
    //Add your detect method here
    return true;
  }

  void handle(Ant being1, Ant being2)
  {
    //Add your handle method here
  }
}