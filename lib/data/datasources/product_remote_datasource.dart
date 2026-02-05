import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-products');
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to load products');
    }
  }
}
