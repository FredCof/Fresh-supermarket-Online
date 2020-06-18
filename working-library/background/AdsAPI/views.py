from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse
from Fresh_market_online.model import User, Ads
import json
from LoginAPI.token_module import get_token,out_token
@csrf_exempt
def AdsGet(request):
    token = request.POST.get("token")
    user = User.objects.filter(token=token)
    data = []
    if user:
        user=user.values()[0]
        telephone = user['phone']
        if out_token(telephone, token):
            if Ads.objects.filter(activate=1):
                ad= Ads.objects.filter(activate=1).values()
                for aitem in ad:
                    type = aitem['type']
                    adsdata = aitem[type]
                    picture = aitem['picture']
                    ads = {"type":type, "data":adsdata, "picture": picture}
                    data.append(ads)
            response = json.dumps(data)
            return HttpResponse(response)
    data = {"message": "Failed"}
    response = json.dumps(data)
    print(response)
    return HttpResponse(response)

@csrf_exempt
def AdsPicture(request):
    id = request.path.rsplit('/', 1)[1]
    print(id)
    path = r'./static/ads_pic' + '/' + id + '.png'
    avatar = open(path, "rb")
    return HttpResponse(avatar.read(), content_type='image/png')