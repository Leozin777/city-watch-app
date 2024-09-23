import 'package:city_watch/data/models/dtos/problema_dto.dart';
import 'package:city_watch/data/models/interface/ihome_service.dart';
import 'package:city_watch/data/service/base_service.dart';

class HomeService extends BaseService implements IHomeService {
  @override
  Future<List<ProblemaDto>> getProblemas() {
    final List<ProblemaDto> _problems = [
      ProblemaDto(
        id: 1,
        nome: 'Problema: Energia',
        endereco: 'Capão da Canoa - RS',
        foto:
            'https://s2-g1.glbimg.com/-eyLCQS3lpD3ceBv2O5SE2IMA0U=/0x0:1280x590/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2021/b/I/SBUkT4T0iC7p2yZZZ7vw/whatsapp-image-2021-05-29-at-16.20.51.jpeg',
        latitude: -29.7588,
        longitude: -50.0476,
      ),
      ProblemaDto(
        id: 2,
        nome: 'Problema: Saúde',
        endereco: 'Porto Alegre - RS',
        foto: 'https://www.gp1.com.br/media/image_bank/2022/5/lixo-e-descartado-em-terreno-baldio.jpg.1500x1000_q85_crop.webp',
        latitude: -30.0277,
        longitude: -51.2287,
      ),
      ProblemaDto(
        id: 3,
        nome: 'Problema: Pavimentação',
        endereco: 'Tramandai - RS',
        foto: 'https://www.mazettoseguros.com.br/blog/wp-content/uploads/2017/01/seguro-auto-cobre-dano-causado-por-buraco-700x525.jpg',
        latitude: -30.0105,
        longitude: -50.1522,
      ),
    ];

    return Future.value(_problems);
  }
}
