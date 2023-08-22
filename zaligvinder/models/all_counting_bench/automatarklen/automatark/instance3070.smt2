(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([012346789][0-9]{4})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9")) ((_ re.loop 4 4) (re.range "0" "9")))))
; LOG\s+spyblpatHost\x3Ais\x2Ephp
(assert (not (str.in_re X (re.++ (str.to_re "LOG") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpatHost:is.php\u{0a}")))))
; Mirar_KeywordContent
(assert (str.in_re X (str.to_re "Mirar_KeywordContent\u{13}\u{0a}")))
; www\x2Ewebcruiser\x2Eccgot
(assert (str.in_re X (str.to_re "www.webcruiser.ccgot\u{0a}")))
; \r\nSTATUS\x3A\dHost\u{3a}Referer\x3AServerSubject\u{3a}
(assert (str.in_re X (re.++ (str.to_re "\u{0d}\u{0a}STATUS:") (re.range "0" "9") (str.to_re "Host:Referer:ServerSubject:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
