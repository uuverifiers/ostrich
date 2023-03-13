(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; RequestedLoggedtb\x2Efreeprod\x2EcomHWAESubject\u{3a}adserver\.warezclient\.com
(assert (not (str.in_re X (str.to_re "RequestedLoggedtb.freeprod.comHWAESubject:adserver.warezclient.com\u{0a}"))))
; ^(~?/|[a-zA-Z]:[\\/]).+
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "~")) (str.to_re "/")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":") (re.union (str.to_re "\u{5c}") (str.to_re "/")))) (re.+ re.allchar) (str.to_re "\u{0a}"))))
; [a-f0-9]{8}-[a-f0-9]{4}-3[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-3") ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") (re.union (str.to_re "8") (str.to_re "9") (str.to_re "a") (str.to_re "b")) ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; zopabora\x2Einfo\s+Inside\s+SystemSleuth\s+www\x2Eyok\x2EcomHost\x3AInformationwww\x2Ezhongsou\x2EcomLite
(assert (str.in_re X (re.++ (str.to_re "zopabora.info") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Inside") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SystemSleuth\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.yok.comHost:Informationwww.zhongsou.comLite\u{0a}"))))
(check-sat)
