(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{2}[0-9]{6}[A-DFM]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "D") (str.to_re "F") (str.to_re "M"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}bcl/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".bcl/i\u{0a}")))))
; /STOR fp[0-9A-F]{44}\u{2e}bin/
(assert (not (str.in_re X (re.++ (str.to_re "/STOR fp") ((_ re.loop 44 44) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re ".bin/\u{0a}")))))
; ^[F][O][\s]?[0-9]{3}$
(assert (not (str.in_re X (re.++ (str.to_re "FO") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; thesearchresltLoggerHost\x3ABetaHWAEHost\x3Ais
(assert (not (str.in_re X (str.to_re "thesearchresltLoggerHost:BetaHWAEHost:is\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
