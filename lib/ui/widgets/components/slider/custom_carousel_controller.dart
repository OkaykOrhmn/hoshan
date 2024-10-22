import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_state.dart';

class CustomCarouselController extends CarouselSliderControllerImpl {
  CarouselState? _state;

  CarouselState? get state => _state;

  @override
  set state(CarouselState? state) {
    _state = state;
    super.state = state;
  }
}
