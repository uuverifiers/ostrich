(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]|[1-9]\d|[1-2]\d{2}|3[0-6][0-6])$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "6") (re.range "0" "6"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}rt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rt/i\u{0a}"))))
; \x7D\x7BTrojan\x3Abacktrust\x2EcomHost\x3Apjpoptwql\u{2f}rlnj
(assert (str.in_re X (str.to_re "}{Trojan:backtrust.comHost:pjpoptwql/rlnj\u{0a}")))
; /filename=[^\n]*\u{2e}fli/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fli/i\u{0a}")))))
; TPSystemHost\x3AHost\u{3a}show\x2Eroogoo\x2EcomX-Mailer\x3A
(assert (not (str.in_re X (str.to_re "TPSystemHost:Host:show.roogoo.comX-Mailer:\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
