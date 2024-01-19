(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d){3})(-)?(\d){2}(-)?(\d){4}(A|B[1-7]?|M|T|C[1-4]|D)$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "A") (re.++ (str.to_re "B") (re.opt (re.range "1" "7"))) (str.to_re "M") (str.to_re "T") (re.++ (str.to_re "C") (re.range "1" "4")) (str.to_re "D")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}bak/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".bak/i\u{0a}")))))
; badurl\x2Egrandstreetinteractive\x2EcomFilteredHost\x3Ae2give\.com\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (str.to_re "badurl.grandstreetinteractive.comFilteredHost:e2give.com/newsurfer4/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
