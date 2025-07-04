import '../reponse/calendar/calendar_detail_response.dart';
import '../reponse/calendar/calendar_reponse.dart';
import '../reponse/calendar/important_date_response.dart';
import '../reponse/calendar/lunar_datetime_response.dart';
import '../reponse/category/categories_data_response.dart';
import '../reponse/expert/expert_data_response.dart';
import 'ai_master_ui_api.dart';

class XheroFetchApiRespository {
  final XheroUIAPI _api;

  XheroFetchApiRespository(this._api);
  //get_category_by_id
  Future<CategoriesDataResponse> getCateById(String id) {
    return _api.getCateById(id);
  }

  //get_calendar
  Future<CalendarResponse> getCalendar(String date) {
    return _api.getCalendar(date);
  }

  //get_calendar_detail
  Future<CalendarDetailResponse> getCalendarDetail(String date) {
    return _api.getCalendarDetail(date);
  }

  //get_home_menu_data
  Future<ImportantDateResponse> getImportantDate(String id) {
    return _api.getImportantDate(id);
  }

  //get_lunar_datetime
  Future<LunarDatetimeResponse> getLunarDatetime(String date, String time) {
    return _api.getLunarDatetime(date, time);
  }

  //get_expert
  Future<ExpertDataResponse> getExpert(String majors, int provinceCode,
      String location, String keyword, int skip) {
    return _api.getExpert(majors, provinceCode, location, keyword, skip);
  }

}
