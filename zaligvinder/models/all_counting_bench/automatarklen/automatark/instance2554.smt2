(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xps/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xps/i\u{0a}"))))
; /filename\=[a-z0-9]{24}\.jar/H
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jar/H\u{0a}")))))
; ^((\.)?([a-zA-Z0-9_-]?)(\.)?([a-zA-Z0-9_-]?)(\.)?)+$
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.opt (str.to_re ".")) (re.opt (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt (str.to_re ".")) (re.opt (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt (str.to_re ".")))) (str.to_re "\u{0a}")))))
; /\u{2e}afm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.afm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; dl\x2Eweb-nexus\x2Enet\d+www\x2Eonlinecasinoextra\x2Ecomsqlads\.grokads\.com
(assert (not (str.in_re X (re.++ (str.to_re "dl.web-nexus.net") (re.+ (re.range "0" "9")) (str.to_re "www.onlinecasinoextra.comsqlads.grokads.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
