import 'package:angel_framework/angel_framework.dart';

abstract class BaseSchema {
  final Service service;

  BaseSchema(Angel app, this.service);

  queryFields() {
    return [];
  }

  mutationFields() {
    return [];
  }

  subscriptionFields() {
    return [];
  }
}
