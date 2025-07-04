// ignore_for_file: no_leading_underscores_for_local_identifiers

part of 'ai_master_ui_api.dart';

class _XheroUIAPI implements XheroUIAPI {
  _XheroUIAPI(this._dio, {this.baseUrl});
  final Dio _dio;
  String? baseUrl;

  //get_category_by_id
  @override
  Future<CategoriesDataResponse> getCateById(String id) async {
    const _extra = <String, dynamic>{};
    final _queryParameters = <String, dynamic>{};
    _queryParameters.addAll({'skip': 0, 'limit': 40});
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CategoriesDataResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'categories/$id',
                    queryParameters: _queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CategoriesDataResponse.fromJson(_result.data!);
    return value;
  }

  //get_calendar
  @override
  Future<CalendarResponse> getCalendar(String date) async {
    const _extra = <String, dynamic>{};
    final _queryParameters = <String, dynamic>{};
    _queryParameters
        .addAll({'date': date, 'isOnlyGetDataFromMonthYear': false});
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CalendarResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'calendars',
                    queryParameters: _queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CalendarResponse.fromJson(_result.data!);
    return value;
  }

  //get_calendar_detail
  @override
  Future<CalendarDetailResponse> getCalendarDetail(String date) async {
    const _extra = <String, dynamic>{};
    final _queryParameters = <String, dynamic>{};
    _queryParameters.addAll({'date': date});
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CalendarDetailResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'calendars/details',
                    queryParameters: _queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CalendarDetailResponse.fromJson(_result.data!);
    return value;
  }

  //get_important_date
  @override
  Future<ImportantDateResponse> getImportantDate(String id) async {
    const _extra = <String, dynamic>{};
    final _queryParameters = <String, dynamic>{};
    _queryParameters.addAll({'skip': 0, 'limit': 9});
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ImportantDateResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'categories/$id',
                    queryParameters: _queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ImportantDateResponse.fromJson(_result.data!);
    return value;
  }

  //get_lunar_datetime
  @override
  Future<LunarDatetimeResponse> getLunarDatetime(
      String date, String time) async {
    const _extra = <String, dynamic>{};
    final _queryParameters = <String, dynamic>{};
    _queryParameters.addAll({'date': date, 'time': time});
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LunarDatetimeResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'calendars/lunar-datetime',
                    queryParameters: _queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LunarDatetimeResponse.fromJson(_result.data!);
    return value;
  }

  //get_expert
  @override
  Future<ExpertDataResponse> getExpert(String majors, int provinceCode,
      String location, String keyword, int skip) async {
    printConsole("ListView goi: $skip");
    const _extra = <String, dynamic>{};
    final _queryParameters = <String, dynamic>{};
    _queryParameters.addAll({
      'location': location,
      'majors': majors,
      'provinceCode': provinceCode,
      'keyword': keyword,
      'skip': skip,
      'limit': 20,
    });
    _queryParameters.removeWhere((key, value) => value == 1000 || value == '');
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ExpertDataResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'experts',
                    queryParameters: _queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ExpertDataResponse.fromJson(_result.data!);
    return value;
  }
  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
