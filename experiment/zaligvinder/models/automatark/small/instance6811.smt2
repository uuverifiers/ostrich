(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/click\?sid=\w{40}\&cid=/Ui
(assert (str.in_re X (re.++ (str.to_re "//click?sid=") ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "&cid=/Ui\u{0a}"))))
; CMDLoginExciteSubject\x3Adownloadfile\u{2e}org
(assert (not (str.in_re X (str.to_re "CMDLoginExciteSubject:downloadfile.org\u{0a}"))))
; /filename=[^\n]*\u{2e}dir/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dir/i\u{0a}"))))
(check-sat)
