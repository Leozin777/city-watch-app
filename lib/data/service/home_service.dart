import 'package:city_watch/data/models/dtos/problema_dto.dart';
import 'package:city_watch/data/models/interface/ihome_service.dart';
import 'package:city_watch/data/service/base_service.dart';

import '../models/enums/e_tipo_problema.dart';

class HomeService extends BaseService implements IHomeService {
  @override
  Future<List<ProblemaDto>> getProblemas() {
    final List<ProblemaDto> _problems = [
      ProblemaDto(
        id: 1,
        nome: 'Problema: Energia',
        endereco: 'Torres - RS',
        foto:
            'https://s2-g1.glbimg.com/-eyLCQS3lpD3ceBv2O5SE2IMA0U=/0x0:1280x590/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2021/b/I/SBUkT4T0iC7p2yZZZ7vw/whatsapp-image-2021-05-29-at-16.20.51.jpeg',
        latitude: -29.337867,
        longitude: -49.727884,
        tipoProblema: ETipoProblema.FaltaDeEnergia,
        likes: 10,
        deslikes: 2,
        nomeDoUsuario: 'João',
      ),
      ProblemaDto(
        id: 2,
        nome: 'Problema: Buraco na rua paizaum',
        endereco: 'Torres - RS',
        foto:
            'https://s2-g1.glbimg.com/-eyLCQS3lpD3ceBv2O5SE2IMA0U=/0x0:1280x590/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2021/b/I/SBUkT4T0iC7p2yZZZ7vw/whatsapp-image-2021-05-29-at-16.20.51.jpeg',
        latitude: -29.335163,
        longitude: -49.733280,
        tipoProblema: ETipoProblema.Infraestrutura,
        likes: 10,
        deslikes: 2,
        nomeDoUsuario: 'João',
      ),
      ProblemaDto(
        id: 1,
        nome: 'Problema: Energia',
        endereco: 'Torres - RS',
        foto:
            'https://s2-g1.glbimg.com/-eyLCQS3lpD3ceBv2O5SE2IMA0U=/0x0:1280x590/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2021/b/I/SBUkT4T0iC7p2yZZZ7vw/whatsapp-image-2021-05-29-at-16.20.51.jpeg',
        latitude: -29.337867,
        longitude: -49.727884,
        tipoProblema: ETipoProblema.FaltaDeEnergia,
        likes: 10,
        deslikes: 2,
        nomeDoUsuario: 'João',
      ),
    ];

    return Future.value(_problems);
  }
}
