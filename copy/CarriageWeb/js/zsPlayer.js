var mySongArray =
            {ifuknew : "https://soundcloud.com/goldpanda/gold-panda-if-u-knew-reprise",
            parallel :"https://soundcloud.com/four-tet/parallel-jalebi",
            bot: "https://soundcloud.com/zenjiskan/cm-bot-m-1/s-sXror?in=zenjiskan/sets/carriage_movement-m/s-lOdvx",
            silverk: "https://soundcloud.com/zenjiskan/cm-silver-k-m/s-aVXA4?in=zenjiskan/sets/carriage_movement-m/s-lOdvx",
            dgrips: "https://soundcloud.com/zenjiskan/cm-ecco-m/s-q80FY?in=zenjiskan/sets/carriage_movement-m/undefined",
            burlin: "https://soundcloud.com/zenjiskan/cm-burlin-m/s-PEa3N?in=zenjiskan/sets/carriage_movement-m/s-lOdvx",
            fourxx: "https://soundcloud.com/zenjiskan/cm-man-grep-m-1/s-aT2gu?in=zenjiskan/sets/carriage_movement-m/s-lOdvx",
            nolove: "https://soundcloud.com/futbook/nolove",
            badtune: "https://soundcloud.com/futbook/badtune",
            sadwive: "https://soundcloud.com/futbook/sadwive",
            russianwinter: "https://soundcloud.com/futbook/russianwnter"}
            
var zsTrackArray =
            {
            bot: "https://soundcloud.com/zenjiskan/cm-bot-m-1/s-sXror?in=zenjiskan/sets/carriage_movement-m/s-lOdvx",
            silverk: "https://soundcloud.com/zenjiskan/cm-silver-k-m/s-aVXA4?in=zenjiskan/sets/carriage_movement-m/s-lOdvx",
            dgrips: "https://soundcloud.com/zenjiskan/cm-ecco-m/s-q80FY?in=zenjiskan/sets/carriage_movement-m/undefined",
            burlin: "https://soundcloud.com/zenjiskan/cm-burlin-m/s-PEa3N?in=zenjiskan/sets/carriage_movement-m/s-lOdvx",
            fourxx: "https://soundcloud.com/zenjiskan/cm-man-grep-m-1/s-aT2gu?in=zenjiskan/sets/carriage_movement-m/s-lOdvx",
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
