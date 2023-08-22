(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /setInterval\s*\u{28}[^\u{29}]+\u{2e}focus\u{28}\u{29}/smi
(assert (str.in_re X (re.++ (str.to_re "/setInterval") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ")"))) (str.to_re ".focus()/smi\u{0a}"))))
; /[^\u{0d}\u{0a}\u{09}\u{20}-\u{7e}]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "\u{09}") (re.range " " "~"))) (str.to_re "/P\u{0a}")))))
; Subject\x3A\s+www\u{2e}proventactics\u{2e}comdownloads\x2Emorpheus\x2Ecom\x2Frotation
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.proventactics.comdownloads.morpheus.com/rotation\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
