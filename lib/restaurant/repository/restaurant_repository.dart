import 'package:acture/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';


@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaruatn
  factory RestaurantRepository(Dio dio, {String baseUrl}) = _RestaurantRepository;

  
  /* @GET('/')
  paginate(); */

  @GET('/{id}')
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
