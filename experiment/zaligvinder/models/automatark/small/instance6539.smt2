(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}HostYWRtaW46cGFzc3dvcmQ
(assert (not (str.in_re X (str.to_re "Subject:HostYWRtaW46cGFzc3dvcmQ\u{0a}"))))
; ^[^-]{1}?[^\"\']*$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.comp (str.to_re "-"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "\u{0a}")))))
; toc=MicrosoftStartupStarLoggerServerX-Mailer\u{3a}
(assert (not (str.in_re X (str.to_re "toc=MicrosoftStartupStarLoggerServerX-Mailer:\u{13}\u{0a}"))))
; /^Host\u{3a}\s*(194.192.14.125|202.75.58.179|flashupdates.info|nvidiadrivers.info|nvidiasoft.info|nvidiastream.info|rendercodec.info|syncstream.info|videosync.info)/smiH
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "194") re.allchar (str.to_re "192") re.allchar (str.to_re "14") re.allchar (str.to_re "125")) (re.++ (str.to_re "202") re.allchar (str.to_re "75") re.allchar (str.to_re "58") re.allchar (str.to_re "179")) (re.++ (str.to_re "flashupdates") re.allchar (str.to_re "info")) (re.++ (str.to_re "nvidiadrivers") re.allchar (str.to_re "info")) (re.++ (str.to_re "nvidiasoft") re.allchar (str.to_re "info")) (re.++ (str.to_re "nvidiastream") re.allchar (str.to_re "info")) (re.++ (str.to_re "rendercodec") re.allchar (str.to_re "info")) (re.++ (str.to_re "syncstream") re.allchar (str.to_re "info")) (re.++ (str.to_re "videosync") re.allchar (str.to_re "info"))) (str.to_re "/smiH\u{0a}")))))
; LOGNetBusCookie\u{3a}Toolbar
(assert (not (str.in_re X (str.to_re "LOGNetBusCookie:Toolbar\u{0a}"))))
(check-sat)
