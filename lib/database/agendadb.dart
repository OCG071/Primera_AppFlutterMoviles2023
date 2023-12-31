import 'dart:async';
import 'dart:io';
import 'package:app1f/models/carrermodel.dart';
import 'package:app1f/models/favoritemoviemodel.dart';
import 'package:app1f/models/locationmodel.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:app1f/models/teachermodel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AgendaDB {
  static final nameDB = 'AGENDADB';
  static final versionDB = 1;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: _createTables
        /* onCreate se ejecuta solo con la creacion de la BD
         onUpgrade se ejecuta con la actualizaciones*/
        );
  }

  FutureOr<void> _createTables(Database db, int version) {
    String query = '''CREATE TABLE tblCarrera(
      idCarrer INTEGER PRIMARY KEY,
      nameCarrer VARCHAR(50)
    );''';

    String query1 = '''CREATE TABLE tblProfesor(
      idTeacher INTEGER PRIMARY KEY,
      nameTeacher VARCHAR(50),
      email VARCHAR(50),
      idCarrer INTEGER, 
      FOREIGN KEY(idCarrer) REFERENCES tblCarrera(idCarrer) 
    );''';

    String query2 = ''' CREATE TABLE tblTareas(
      idTask INTEGER PRIMARY KEY,
      dateE TEXT,
      dateR TEXT,
      nameTask VARCHAR(50),
      descTask TEXT,
      sttTask BYTE, 
      idTeacher INT,
      FOREIGN KEY(idTeacher) REFERENCES tblProfesor(idTeacher)
    );''';

    String query3 = '''INSERT INTO tblCarrera(nameCarrer) values
      ('Ingeniería en Sistemas Computacionales'),
      ('Ingeniería Industrial'),
      ('Ingeniería Mecánica')
      ;''';

    String query4 =
        '''INSERT INTO tblProfesor(nameTeacher,email,idCarrer) values
        ('Rubén Torres Frías','ruben.torres@itcelaya.edu.mx',1 ),
        ('Patricia Galván Morales',' patricia.galvan@itcelaya.edu.mx',1 ),
        ('Leopoldo Ortíz Alba','leopoldo.ortiz@itcelaya.edu.mx',2),
        ('Leticia Martínez Sierra','leticia.martinez@itcelaya.edu.mx',2),
        ('Karla Anhel Camarillo Gómez','karla.camarillo@itcelaya.edu.mx',3),
        ('Horacio Orozco Mendoza','horacio.orozco@itcelaya.edu.mx',3)
        ;''';

    String query5 = '''CREATE TABLE tblFavoritaPelicula(
          idFavorite INTEGER PRIMARY KEY,
          nameMovie varchar(200),
          image varchar(200)
      )''';

    String query6 = '''CREATE TABLE tblClima(
      idLocation varchar(100) PRIMARY KEY,
      lon REAL,
      lat REAL,
      name varchar(100)
    )''';

    String query7 = '''INSERT INTO tblClima(idLocation,lon,lat,name) values
                      ('YO', 0.0, 0.0, 'Mi Ubicación')''';

    List<String> queries = [
      query,
      query1,
      query2,
      query3,
      query4,
      query5,
      query6,
      query7,
    ];
    for (var q in queries) {
      db.execute(q);
    }
  }

  Future<int> INSERT(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert(tblName, data);
  }

  Future<int> UPDATE(
      String tblName, String tblId, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.update(tblName, data,
        where: '$tblId = ?', whereArgs: [data['$tblId']]);
  }

  Future<int> DELETE(String tblName, String tblId, int id) async {
    var conexion = await database;
    return conexion!.delete(tblName, where: '$tblId = ?', whereArgs: [id]);
  }

  Future<int> DELETE_STRING(String tblName, String tblId, String id) async {
    var conexion = await database;
    return conexion!.delete(tblName, where: '$tblId = ?', whereArgs: [id]);
  }

  Future<List<TaskModel>> GETALLTASK() async {
    var conexion = await database;
    var result = await conexion!.query('tblTareas');
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<List<Map<String, dynamic>>?> GETTASKS() async {
    var conexion = await database;
    return conexion!.query('tblTareas');
  }

  Future<List<TaskModel>> GETTASKDATE(String date) async {
    var conexion = await database;
    var result = await conexion!
        .rawQuery('SELECT * FROM tblTareas where dateE = ?', ['$date']);
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<List<TaskModel>> GETTASKSST(String status) async {
    var conexion = await database;
    var result = await conexion!
        .rawQuery('SELECT * FROM tblTareas where sttTask = ?', ['$status']);
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<List<TeacherModel>> GETALLTEACHER() async {
    var conexion = await database;
    var result = await conexion!.query('tblProfesor');
    return result.map((teacher) => TeacherModel.fromMap(teacher)).toList();
  }

  Future<List<CarrerModel>> GETALLCARRER() async {
    var conexion = await database;
    var result = await conexion!.query('tblCarrera');
    return result.map((carrer) => CarrerModel.fromMap(carrer)).toList();
  }

  Future<List<FavoriteMovieModel>> GETALLFAVMOV() async {
    var conexion = await database;
    var result = await conexion!.query('tblFavoritaPelicula');
    return result.map((movie) => FavoriteMovieModel.fromMap(movie)).toList();
  }

  Future<List<LocationModel>> GETALLLOCATIONS() async {
    var conexion = await database;
    var result = await conexion!.query('tblClima');
    return result.map((location) => LocationModel.fromMap(location)).toList();
  }

  Future<List<Map<String, dynamic>>> GETALLCARRERNAME() async {
    var conexion = await database;
    return await conexion!.rawQuery('SELECT nameCarrer FROM tblCarrera');
  }

  Future<List<Map<String, dynamic>>> GETALLTEACHERNAME() async {
    var conexion = await database;
    return await conexion!.rawQuery('SELECT nameTeacher FROM tblProfesor');
  }

  Future<List<Map<String, dynamic>>> GET_LOCATIONS() async {
    var conexion = await database;
    return await conexion!.rawQuery('SELECT * FROM tblClima');
  }

  Future<List<Map<String, dynamic>>> GETCARRERNAME(int idCarrer) async {
    var conexion = await database;
    return await conexion!.rawQuery(
        'SELECT nameCarrer FROM tblCarrera WHERE idCarrer = ?', ['$idCarrer']);
  }

  Future<List<Map<String, dynamic>>> GETTEACHERNAME(int idTeacher) async {
    var conexion = await database;
    return await conexion!.rawQuery(
        'SELECT nameTeacher FROM tblProfesor WHERE idTeacher = ?',
        ['$idTeacher']);
  }

  Future<int?> GETTASKIDTEACHER(int idTeacher) async {
    var conexion = await database;
    final int? reg = Sqflite.firstIntValue(await conexion!.rawQuery(
        'SELECT COUNT(*) FROM tblTareas WHERE idTeacher = ?', ['$idTeacher']));
    return reg;
  }

  Future<int?> GETTEACHERIDCARRER(int idCarrer) async {
    var conexion = await database;
    final int? reg = Sqflite.firstIntValue(await conexion!.rawQuery(
        'SELECT COUNT(*) FROM tblProfesor WHERE idCarrer = ?', ['$idCarrer']));
    return reg;
  }

  Future<int?> GETFAVORITESINT(int idFavorite) async {
    var conexion = await database;
    final int? reg = Sqflite.firstIntValue(await conexion!.rawQuery(
        'SELECT COUNT(*) FROM tblFavoritaPelicula WHERE idFavorite = ?',
        ['$idFavorite']));
    return reg;
  }

  Future<List<Map<String, dynamic>>> GETCARRERID(String carrer) async {
    var conexion = await database;
    return await conexion!.rawQuery(
        'SELECT idCarrer FROM tblCarrera WHERE nameCarrer = ?', ['$carrer']);
  }

  Future<List<Map<String, dynamic>>> GETTEACHERID(String teacher) async {
    var conexion = await database;
    return await conexion!.rawQuery(
        'SELECT idTeacher FROM tblProfesor WHERE nameTeacher = ?',
        ['$teacher']);
  }
}
