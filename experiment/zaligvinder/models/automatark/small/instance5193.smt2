(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; YAHOODesktopHost\u{3a}LOGHost\x3AtvshowticketsResultsFROM\x3A
(assert (not (str.in_re X (str.to_re "YAHOODesktopHost:LOGHost:tvshowticketsResultsFROM:\u{0a}"))))
; DesktopSupportFiles\x2EhtmlReferer\x3Awww\x2Efreescratchandwin\x2Ecom
(assert (not (str.in_re X (str.to_re "DesktopSupportFiles\u{13}.htmlReferer:www.freescratchandwin.com\u{0a}"))))
; /filename=[^\n]*\u{2e}pfa/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfa/i\u{0a}"))))
; ^\([0-9]{3}\)\s?[0-9]{3}(-|\s)?[0-9]{4}$|^[0-9]{3}-?[0-9]{3}-?[0-9]{4}$
(assert (str.in_re X (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^((([A-PR-UWYZ](\d([A-HJKSTUW]|\d)?|[A-HK-Y]\d([ABEHMNPRVWXY]|\d)?))\s*(\d[ABD-HJLNP-UW-Z]{2})?)|GIR\s*0AA)$
(assert (str.in_re X (re.++ (re.union (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "H") (str.to_re "J") (str.to_re "L") (str.to_re "N") (re.range "P" "U") (re.range "W" "Z"))))) (re.union (re.range "A" "P") (re.range "R" "U") (str.to_re "W") (str.to_re "Y") (str.to_re "Z")) (re.union (re.++ (re.range "0" "9") (re.opt (re.union (re.range "A" "H") (str.to_re "J") (str.to_re "K") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "W") (re.range "0" "9")))) (re.++ (re.union (re.range "A" "H") (re.range "K" "Y")) (re.range "0" "9") (re.opt (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "V") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (re.range "0" "9")))))) (re.++ (str.to_re "GIR") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "0AA"))) (str.to_re "\u{0a}"))))
(check-sat)
