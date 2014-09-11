var mySongArray =
            {ifuknew : "https://soundcloud.com/goldpanda/gold-panda-if-u-knew-reprise",
            parallel :"https://soundcloud.com/four-tet/parallel-jalebi",
            bot: "https://soundcloud.com/variclap/1-cm-bot-m/s-yomjh?in=variclap/sets/carriage_movement/s-WAUlo",
            silverk: "https://soundcloud.com/variclap/2-cm-silver-k-m/s-KEqvI?in=variclap/sets/carriage_movement/s-WAUlo",
            dgrips: "https://soundcloud.com/variclap/3-cm-ecco-m/s-WAUlo?in=variclap/sets/carriage_movement/s-WAUlo",
            burlin: "https://soundcloud.com/variclap/4-cm-burlin-m/s-WAUlo?in=variclap/sets/carriage_movement/s-WAUlo",
            fourxx: "https://soundcloud.com/variclap/5-cm-man-grep-m/s-qT6CF?in=variclap/sets/carriage_movement/s-WAUlo",
            }

function playTracks(tracks, volume, repeat, shuffle){
            var $zsPlayer=$("#zsPlayer .sc-player");
            $.scPlayer.clearPlayList($zsPlayer);
            var myLinks= [];
            for (track in tracks){
                myLinks.push({url:mySongArray[tracks[track]], title: mySongArray[tracks[track]]})
            }
            $zsPlayer.scPlayer({links: myLinks, autoPlay:true, repeat: repeat, volume: volume, randomize: shuffle});
}

function loadTracks(tracks, volume, repeat, shuffle){
            var $zsPlayer=$("#zsPlayer .sc-player");
            $.scPlayer.clearPlayList($zsPlayer);
            var myLinks= [];
            for (track in tracks){
                myLinks.push({url:mySongArray[tracks[track]], title: mySongArray[tracks[track]]})
            }
            $zsPlayer.scPlayer({links: myLinks, autoPlay:false, repeat: repeat, volume: volume, randomize: shuffle});
}

function playFirstTrack($zsPlayer){
            $.scPlayer.playFirstTrack($zsPlayer);
}
