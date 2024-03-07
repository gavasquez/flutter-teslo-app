// Esta clase va a proporcionar todas las implementaciones que voy hacer para cambiar las sharedpreferences
abstract class KeyValueSotrageService {
  // se pone asi <T> a la funcion para que trate el valor como ese generico, si se pone String lo tata como un String, number a number...
  Future<void> setKeyValue<T>(String key, T value);
  // Se Future<T?> porque la funcion recibe un generico entonces va a retornar lo que se le ponga y que lo trate como opcional
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey(String key);
}
