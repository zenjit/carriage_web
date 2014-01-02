var mySongArray =
            {ifuknew : "https://soundcloud.com/goldpanda/gold-panda-if-u-knew-reprise",
            parallel :"https://soundcloud.com/four-tet/parallel-jalebi",
            nolove: "https://soundcloud.com/futbook/nolove",
            badtune: "https://soundcloud.com/futbook/badtune",
            sadwive: "https://soundcloud.com/futbook/sadwive",
            russianwinter: "https://soundcloud.com/futbook/russianwnter"}
            
var zsTrackArray =
            {
            bot: "https://soundcloud.com/zenjiskan/boards-of-tibet-1/s-ZeYmP",
            silverk: "https://soundcloud.com/zenjiskan/silver-k-1/s-ZeYmP",
            dgrips: "https://soundcloud.com/zenjiskan/grips-1/s-ZeYmP",
            burlin: "https://soundcloud.com/zenjiskan/burlin-1/s-ZeYmP",
            fourxx: "https://soundcloud.com/zenjiskan/xx-1/s-ZeYmP",
            }

function playTracks(tracks, volume, repeat){
            var $zsPlayer=$("#zsPlayer .sc-player");
            $.scPlayer.clearPlayList($zsPlayer);
            var myLinks= [];
            for (track in tracks){
                myLinks.push({url:mySongArray[tracks[track]], title: mySongArray[tracks[track]]})
            }
            $zsPlayer.scPlayer({links: myLinks, autoPlay:true, repeat: repeat, volume: volume});
}

function playFirstTrack($zsPlayer){
            $.scPlayer.playFirstTrack($zsPlayer);
}
