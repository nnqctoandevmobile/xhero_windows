
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:xhero_windows_app/reponse/calendar/calendar_reponse.dart';

import '../reponse/calendar/calendar_detail_response.dart';
import '../reponse/calendar/important_date_response.dart';
import '../reponse/calendar/lunar_datetime_response.dart';
import '../reponse/category/categories_data_response.dart';
import '../reponse/expert/expert_data_response.dart';
import '../utils/logic/xhero_common_logics.dart';

part 'ai_master_ui_api.g.dart';

@RestApi()
abstract class XheroUIAPI {
  factory XheroUIAPI(Dio dio, {String baseUrl}) = _XheroUIAPI;
  //get_category_by_id
  @GET('categories')
  Future<CategoriesDataResponse> getCateById(String id);
  //get_calendar_month
  @GET('calendars')
  Future<CalendarResponse> getCalendar(String date);
  //get_calendar_detail
  @GET('calendars/details')
  Future<CalendarDetailResponse> getCalendarDetail(String date);
  //get_important_date
  @GET('categories/1')
  Future<ImportantDateResponse> getImportantDate(String id);
  //get_lunar_datetime
  @GET('calendars/lunar-datetime')
  Future<LunarDatetimeResponse> getLunarDatetime(String date, String time);
  //get_expert
  @GET('expert')
  Future<ExpertDataResponse> getExpert(String majors, int provinceCode,
      String location, String keyword, int skip);
  // //get_order
  // @GET('orders')
  // Future<ListItemResponse> getOrder(String address, String status, String orderCode,
  // String fromName, String fromPhone, String birthDay, String fromDate, String detail);
}
