(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \.cfg\d+stale\d+GmbHPG=SPEEDBARcuReferer\x3ASpediazmnjgmomgbdz\u{2f}zzmw\.gztHost\x3AHost\x3Azopabora\x2Einfo
(assert (str.in_re X (re.++ (str.to_re ".cfg") (re.+ (re.range "0" "9")) (str.to_re "stale") (re.+ (re.range "0" "9")) (str.to_re "GmbHPG=SPEEDBARcuReferer:Spediazmnjgmomgbdz/zzmw.gztHost:Host:zopabora.info\u{0a}"))))
; \w*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /\?java\=[0-9]{2,6}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/?java=") ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; snprtz\x7Cdialnoref\x3D\u{25}user\x5FidPG=SPEEDBAR
(assert (str.in_re X (str.to_re "snprtz|dialnoref=%user_idPG=SPEEDBAR\u{0a}")))
(check-sat)
