(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0|[1-9]+[0-9]*)-(0|[1-9]+[0-9]*);|(0|[1-9]+[0-9]*);)*?((0|[1-9]+[0-9]*)-(0|[1-9]+[0-9]*)|(0|[1-9]+[0-9]*)){1}$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "-") (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re ";")) (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re ";")))) ((_ re.loop 1 1) (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "-") (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))) (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; www\x2Elookster\x2Enetnotificationuuid=qisezhin\u{2f}iqor\.ym
(assert (str.in_re X (str.to_re "www.lookster.netnotification\u{13}uuid=qisezhin/iqor.ym\u{13}\u{0a}")))
; [0-1]+
(assert (str.in_re X (re.++ (re.+ (re.range "0" "1")) (str.to_re "\u{0a}"))))
; /^Host\u{3a}\s*(194.192.14.125|202.75.58.179|flashupdates.info|nvidiadrivers.info|nvidiasoft.info|nvidiastream.info|rendercodec.info|syncstream.info|videosync.info)/smiH
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "194") re.allchar (str.to_re "192") re.allchar (str.to_re "14") re.allchar (str.to_re "125")) (re.++ (str.to_re "202") re.allchar (str.to_re "75") re.allchar (str.to_re "58") re.allchar (str.to_re "179")) (re.++ (str.to_re "flashupdates") re.allchar (str.to_re "info")) (re.++ (str.to_re "nvidiadrivers") re.allchar (str.to_re "info")) (re.++ (str.to_re "nvidiasoft") re.allchar (str.to_re "info")) (re.++ (str.to_re "nvidiastream") re.allchar (str.to_re "info")) (re.++ (str.to_re "rendercodec") re.allchar (str.to_re "info")) (re.++ (str.to_re "syncstream") re.allchar (str.to_re "info")) (re.++ (str.to_re "videosync") re.allchar (str.to_re "info"))) (str.to_re "/smiH\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
