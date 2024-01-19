(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(Frame)?\.jsf/R
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "Frame")) (str.to_re ".jsf/R\u{0a}")))))
; (Mo(n(day)?)?|Tu(e(sday)?)?|We(d(nesday)?)?|Th(u(rsday)?)?|Fr(i(day)?)?|Sa(t(urday)?)?|Su(n(day)?)?)
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "Mo") (re.opt (re.++ (str.to_re "n") (re.opt (str.to_re "day"))))) (re.++ (str.to_re "Tu") (re.opt (re.++ (str.to_re "e") (re.opt (str.to_re "sday"))))) (re.++ (str.to_re "We") (re.opt (re.++ (str.to_re "d") (re.opt (str.to_re "nesday"))))) (re.++ (str.to_re "Th") (re.opt (re.++ (str.to_re "u") (re.opt (str.to_re "rsday"))))) (re.++ (str.to_re "Fr") (re.opt (re.++ (str.to_re "i") (re.opt (str.to_re "day"))))) (re.++ (str.to_re "Sa") (re.opt (re.++ (str.to_re "t") (re.opt (str.to_re "urday"))))) (re.++ (str.to_re "Su") (re.opt (re.++ (str.to_re "n") (re.opt (str.to_re "day")))))) (str.to_re "\u{0a}")))))
; \b(((20)((0[0-9])|(1[0-1])))|(([1][^0-8])?\d{2}))((0[1-9])|1[0-2])((0[1-9])|(2[0-9])|(3[01]))[-+]?\d{4}[,.]?\b
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "20") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "1")))) (re.++ (re.opt (re.++ (str.to_re "1") (re.range "0" "8"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.opt (re.union (str.to_re "-") (str.to_re "+"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re ",") (str.to_re "."))) (str.to_re "\u{0a}"))))
; weatherSubject\u{3a}X-Mailer\u{3a}TOOLBAR\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (str.to_re "weatherSubject:X-Mailer:\u{13}TOOLBAR/newsurfer4/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
