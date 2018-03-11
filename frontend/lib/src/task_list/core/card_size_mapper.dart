
/// Maps list-model to height in pixels
abstract class CardSizeMapper<TModel> {
  int getHeight(TModel model);
}