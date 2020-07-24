from django.http import JsonResponse
from .models import Rmp

def index(request):
    if request.method == 'POST':
        song_json = json.loads(request.body, 'utf-8')
        Rmp.objects.update_or_create(file=song_json['file'], defaults=song_json)
    else:
        list = {}
        list['music'] = [data for data in Rmp.objects.all]
        
        db_update_song = {}
        while True:
            play_now = False
            for data in list['music']:
                if data['now'] == 0:
                    play_now = True
                    break:

            if not play_now:
                for data in list['music']:
                    if 0 < data['now']:
                        data['now'] -= 1
                        db_update_song[data['file']] = data['now']
                    else:
                        break

        for song in db_update_song:
            Rmp.objects.update(file=song, defaults=db_update_song[song])

        return JsonResponse(list, json_dumps_params={'ensure_ascii': False, 'indent': 2})

    


