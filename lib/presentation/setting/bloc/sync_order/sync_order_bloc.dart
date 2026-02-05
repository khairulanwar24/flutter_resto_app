import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_order_event.dart';
part 'sync_order_state.dart';
part 'sync_order_bloc.freezed.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  SyncOrderBloc(this.orderRemoteDatasource) : super(const _Initial()) {
    on<SyncOrderEvent>((event, emit) async {
      emit(const _Loading());
      final dataOrderNotSynced = await ProductLocalDatasource.instance
          .getOrderByIsNotSync(); //get orders that not synced
      for (var order in dataOrderNotSynced) {
        final result = await orderRemoteDatasource.saveOrder(order);
        if (result) {
          //update order is_sync to true
          await ProductLocalDatasource.instance.updateOrderIsSync(order.id!);
        } else {
          emit(const _Error('Failed to sync orders'));
          return;
        }
      }
    });
  }
}
