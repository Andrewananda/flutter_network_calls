


class NetworkResponse<T> {

  Status status;
  T? data;
  String? message;

  NetworkResponse.success(this.data) : status = Status.COMPLETED;
  NetworkResponse.error(this.message) : status = Status.ERROR;
  NetworkResponse.loading(this.message): status = Status.LOADING;
  NetworkResponse.initial(this.message): status = Status.INITIAL;


}

enum Status  { INITIAL, LOADING, COMPLETED, ERROR }