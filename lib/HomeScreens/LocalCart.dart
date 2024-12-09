


class LocalCart {
   int summaOfCart=0;

   final List<Map<String, dynamic>> vebinarChooseList = [];

   addToCart(Map<String, dynamic> vebinar){
      vebinarChooseList.add(vebinar);
      summaOfCart+=vebinar['cost'] as int;
   }
   deleteFromCart(Map<String, dynamic> vebinar){
      summaOfCart-=vebinar['cost'] as int;
      vebinarChooseList.removeWhere((item) => item['word'] == vebinar['word']);
   }

}
