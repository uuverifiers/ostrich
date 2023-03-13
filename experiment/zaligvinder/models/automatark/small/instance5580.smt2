(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9A-Za-z_ ]+(.[jJ][pP][gG]|.[gG][iI][fF])$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " "))) (str.to_re "\u{0a}") re.allchar (re.union (re.++ (re.union (str.to_re "j") (str.to_re "J")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "g") (str.to_re "G"))) (re.++ (re.union (str.to_re "g") (str.to_re "G")) (re.union (str.to_re "i") (str.to_re "I")) (re.union (str.to_re "f") (str.to_re "F")))))))
; LOGLiveHost\x3ALOGHandyhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (str.to_re "LOGLiveHost:LOGHandyhttp://www.searchinweb.com/search.php?said=bar\u{0a}")))
; ^([a-zA-Z0-9][a-zA-Z0-9_]*(\.{0,1})?[a-zA-Z0-9\-_]+)*(\.{0,1})@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|([a-zA-Z0-9\-]+(\.([a-zA-Z]{2,10}))(\.([a-zA-Z]{2,10}))?(\.([a-zA-Z]{2,10}))?))[\s]*$
(assert (not (str.in_re X (re.++ (re.* (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (re.opt (re.opt (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))))) (re.opt (str.to_re ".")) (str.to_re "@") (re.union (re.++ (str.to_re "[") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; com\x2Findex\.php\?tpid=\x7D\x7BUser\x3A
(assert (str.in_re X (str.to_re "com/index.php?tpid=}{User:\u{0a}")))
; /agent_(win|lin|mac)_helper\.jar$/siU
(assert (str.in_re X (re.++ (str.to_re "/agent_") (re.union (str.to_re "win") (str.to_re "lin") (str.to_re "mac")) (str.to_re "_helper.jar/siU\u{0a}"))))
(check-sat)
