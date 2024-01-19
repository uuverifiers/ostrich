(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eonlinecasinoextra\x2Ecomsearchreslt\x7D\x7BSysuptime\x3A
(assert (not (str.in_re X (str.to_re "www.onlinecasinoextra.comsearchreslt}{Sysuptime:\u{0a}"))))
; /\u{2e}xspf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.xspf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /\(\?[gimxs]{1,5}\)/
(assert (not (str.in_re X (re.++ (str.to_re "/(?") ((_ re.loop 1 5) (re.union (str.to_re "g") (str.to_re "i") (str.to_re "m") (str.to_re "x") (str.to_re "s"))) (str.to_re ")/\u{0a}")))))
; /filename=[^\n]*\u{2e}eot/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".eot/i\u{0a}"))))
; /filename=[^\n]*\u{2e}cgm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cgm/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
