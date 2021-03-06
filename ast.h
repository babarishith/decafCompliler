#ifndef _AST_H
#define _AST_H
#include <vector>
#include <string>
#include <cstdio>
#include "visitor.h"
extern std::ofstream outfile;

class ASTProgram;
class ASTFieldDecl;
class ASTVarDecl;
class ASTIdentifier;
class ASTVarIdentifier;
class ASTArrayIdentifier;
class ASTMethodDecl;
class ASTTypeIdentifier;
class ASTStatement;
class ASTExpression;
class ASTBlockStatement;
class ASTAssignmentStatement;
class ASTMethodCall;
class ASTNormalMethod;
class ASTCalloutMethod;
class ASTCalloutArg;
class ASTStringCalloutArg;
class ASTExpressionCalloutArg;
class ASTIfStatement;
class ASTForStatement;
class ASTReturnStatement;
class ASTContinueStatement;
class ASTBreakStatement;
class ASTLocation;
class ASTVarLocation;
class ASTArrayLocation;
class ASTLiteralExpression;
class ASTIntegerLiteralExpression;
class ASTCharLiteralExpression;
class ASTTrueLiteralExpression;
class ASTFalseLiteralExpression;
class ASTBinaryOperationExpression;
class ASTUnaryOperationExpression;

enum class BinOp : char {
    plus_op,
    minus_op,
    multiply_op,
    divide_op,
    modulo_op,
    lessthan_op,
    greaterthan_op,
    lessequal_op,
    greaterequal_op,
    notequal_op,
    equalequal_op,
    and_op,
    or_op
};

enum class Datatype : char {
    int_type,
    void_type,
    bool_type
};

enum class AssignOp : char {
    plus_equal,
    minus_equal,
    equal
};

enum class UnOp : char {
    minus_op,
    not_op
};

class ASTNode {
    public:
        ASTNode() {
        }
        ~ASTNode() {
        }
        virtual void accept(Visitor * v) = 0;
        std::string parseBinOp(BinOp op){
            switch(op){
                case BinOp::plus_op: 
                    return "+";
                case BinOp::minus_op: 
                    return "-";
                case BinOp::multiply_op: 
                    return "*";
                case BinOp::divide_op: 
                    return "/";
                case BinOp::modulo_op: 
                    return "%";
                case BinOp::lessthan_op: 
                    return "<";
                case BinOp::greaterthan_op: 
                    return ">";
                case BinOp::lessequal_op: 
                    return "<=";
                case BinOp::greaterequal_op: 
                    return ">=";
                case BinOp::notequal_op: 
                    return "!=";
                case BinOp::equalequal_op: 
                    return "==";
                case BinOp::and_op: 
                    return "&&";
                case BinOp::or_op: 
                    return "||";
            }
            return "";
        }

        std::string parseDatatype(Datatype type){
            switch(type){
                case Datatype::int_type: 
                    return "int";
                case Datatype::void_type: 
                    return "void";
                case Datatype::bool_type: 
                    return "bool";
            }
            return "";
        }

        std::string parseUnOp(UnOp op){
            switch(op){
                case UnOp::minus_op: 
                    return "-";
                case UnOp::not_op: 
                    return "!";
            }
            return "";
        }

        std::string parseAssignOp(AssignOp op){
            switch(op){
                case AssignOp::plus_equal: 
                    return "+=";
                case AssignOp::minus_equal: 
                    return "-=";
                case AssignOp::equal: 
                    return "=";
            }
            return "";
        }
};

class ASTProgram : public ASTNode
{
    std::string id;
    std::vector<ASTFieldDecl *> * fdl;
    std::vector<ASTMethodDecl *> * mdl;
    public:
    ASTProgram(std::string id, std::vector<ASTFieldDecl *> * fdl, std::vector<ASTMethodDecl *> * mdl){
        this->id = id;
        this->mdl = mdl;
        this->fdl = fdl;
    }
    std::string getId(){
        return this->id;
    }
    std::vector<ASTMethodDecl *> * getMdl() {
        return this->mdl;
    }
    std::vector<ASTFieldDecl *> * getFdl() {
        return this->fdl;
    }
    ~ASTProgram() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTFieldDecl : public ASTNode
{
    Datatype type;
    std::vector<ASTVarIdentifier *> * var_id_list;
    std::vector<ASTArrayIdentifier *> * array_id_list;
    public:
    ASTFieldDecl(std::vector<ASTVarIdentifier *> * var_id_list, Datatype type){
        this->type = type;
        this->var_id_list = var_id_list;
        this->array_id_list = NULL;
    }
    ASTFieldDecl(std::vector<ASTArrayIdentifier *> * array_id_list, Datatype type){
        this->type = type;
        this->array_id_list = array_id_list;
        this->var_id_list = NULL;
    }
    std::vector<ASTVarIdentifier *> * getVar_id_list() {
        return this->var_id_list;
    }
    std::vector<ASTArrayIdentifier *> * getArray_id_list() {
        return this->array_id_list;
    }
    Datatype getType() {
        return this->type;
    }
    ~ASTFieldDecl() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTVarDecl : public ASTNode
{
    Datatype type;
    std::vector<ASTVarIdentifier *> * id_list;
    public:
    ASTVarDecl(std::vector<ASTVarIdentifier *> * id_list, Datatype type) {
        this->type = type;
        this->id_list = id_list;
    }
    std::vector<ASTVarIdentifier *> * getId_list() {
        return this->id_list;
    }
    Datatype getType() {
        return this->type;
    }
    ~ASTVarDecl() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTIdentifier : public ASTNode 
{
    public: 
        ASTIdentifier() {

        }
        ~ASTIdentifier() {

        }
        virtual void accept(Visitor * v) = 0;
};

class ASTVarIdentifier : public ASTIdentifier
{
    std::string id;
    public:
    ASTVarIdentifier(std::string id) {
        this->id = id;
    }
    std::string getId() {
        return this->id;
    }
    ~ASTVarIdentifier() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTArrayIdentifier : public ASTIdentifier 
{
    std::string id;
    int size;
    public:
    ASTArrayIdentifier(std::string id, int size) {
        this->id = id;
        this->size = size;      
    }
    std::string getId() {
        return this->id;
    }
    int getSize() {
        return this->size;
    }
    ~ASTArrayIdentifier() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTMethodDecl : public ASTNode
{
    std::string id;
    Datatype returnType;
    std::vector<ASTTypeIdentifier *> * arguments;
    ASTBlockStatement * block;
    public:
    ASTMethodDecl(std::string id, Datatype returnType, std::vector<ASTTypeIdentifier *> * arguments, ASTBlockStatement * block) {
        this->id = id;
        this->returnType = returnType;
        this->arguments = arguments;
        this->block = block;
    }
    std::string getId() {
        return this->id;
    }
    Datatype getReturnType() {
        return this->returnType;
    }
    std::vector<ASTTypeIdentifier *> * getArguments() {
        return this->arguments;
    }
    ASTBlockStatement * getBlock() {
        return this->block;
    }
    ~ASTMethodDecl() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTTypeIdentifier : public ASTNode
{
    std::string id;
    Datatype type;
    public:
    ASTTypeIdentifier(std::string id, Datatype type) {
        this->id = id;
        this->type = type;
    }
    ~ASTTypeIdentifier() {

    }
    std::string getId() {
        return this->id;
    }
    Datatype getType() {
        return this->type;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTStatement : public ASTNode 
{
    public:
        ASTStatement() {

        }
        ~ASTStatement() {

        }
        virtual void accept(Visitor * v) = 0;
};


class ASTExpression : public ASTNode
{
    public:
        ASTExpression() {

        }
        ~ASTExpression() {

        }
        virtual void accept(Visitor * v) = 0;
};

class ASTBlockStatement : public ASTStatement
{
    std::vector<ASTVarDecl *> * id_list;
    std::vector<ASTStatement *> * stmtlist;
    public:
    ASTBlockStatement(std::vector<ASTStatement *> * stmtlist, std::vector<ASTVarDecl *> * id_list) {
        this->stmtlist = stmtlist;
        this->id_list = id_list;
    }
    std::vector<ASTVarDecl *> * getId_list() {
        return this->id_list;
    }
    std::vector<ASTStatement *> * getStmtlist() {
        return this->stmtlist;
    }
    ~ASTBlockStatement() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTAssignmentStatement : public ASTStatement
{
    AssignOp op;
    ASTLocation * location;
    ASTExpression * expr;
    public:
    ASTAssignmentStatement(AssignOp op, ASTLocation * location, ASTExpression * expr) {
        this->op = op;
        this->location = location;
        this->expr = expr;
    }
    AssignOp getOp() {
        return this->op;
    }
    ASTLocation * getLocation() {
        return this->location;
    }
    ASTExpression * getExpr() {
        return this->expr;
    }
    ~ASTAssignmentStatement() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTMethodCall : public ASTStatement, public ASTExpression 
{
    public:
        ASTMethodCall() {

        }
        ~ASTMethodCall() {

        }
        virtual void accept(Visitor * v) = 0;
};

class ASTNormalMethod : public ASTMethodCall 
{
    std::string id;
    std::vector<ASTExpression *> * arguments;
    public:
    ASTNormalMethod(std::string id, std::vector<ASTExpression *> * arguments) {
        this->id = id;
        this->arguments = arguments;
    }
    std::string getId() {
        return this->id;
    }
    std::vector<ASTExpression *> * getArguments() {
        return this->arguments;
    }
    ~ASTNormalMethod() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTCalloutMethod : public ASTMethodCall 
{
    std::string method_name;
    std::vector<ASTCalloutArg *> * arguments;
    public:
    ASTCalloutMethod(std::string method_name, std::vector<ASTCalloutArg *> * arguments) {
        this->method_name = method_name;
        this->arguments = arguments;
    }
    std::string getMethod_name() {
        return this->method_name;
    }
    std::vector<ASTCalloutArg *> * getArguments() {
        return this->arguments;
    }
    ~ASTCalloutMethod() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTCalloutArg : public ASTExpression
{
    public:
        ASTCalloutArg() {

        }
        ~ASTCalloutArg() {

        }
};

class ASTStringCalloutArg : public ASTCalloutArg 
{
    std::string argument;
    public:
    ASTStringCalloutArg(std::string argument) {
        this->argument = argument;
    }
    std::string getArgument() {
        return this->argument;
    }
    ~ASTStringCalloutArg() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTExpressionCalloutArg : public ASTCalloutArg 
{
    ASTExpression * argument;
    public:
    ASTExpressionCalloutArg(ASTExpression * argument) {
        this->argument = argument;
    }
    ASTExpression * getArgument() {
        return this->argument;
    }
    ~ASTExpressionCalloutArg() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTIfStatement : public ASTStatement 
{
    ASTExpression * condition;
    ASTBlockStatement * if_block;
    ASTBlockStatement * else_block;
    public:
    ASTIfStatement(ASTExpression * condition, ASTBlockStatement * if_block, ASTBlockStatement * else_block) {
        this->condition = condition;
        this->if_block = if_block;
        this->else_block = else_block;
    }
    ASTExpression * getCondition() {
        return this->condition;
    }
    ASTBlockStatement * getIf_block() {
        return this->if_block;
    }
    ASTBlockStatement * getElse_block() {
        return this->else_block;
    }
    ~ASTIfStatement() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTForStatement : public ASTStatement 
{
    std::string id;
    ASTExpression * init_condition;
    ASTExpression * end_condition;
    ASTBlockStatement * block;
    public:
    ASTForStatement(ASTExpression * init_condition, ASTExpression * end_condition, ASTBlockStatement * block, std::string id) {
        this->init_condition = init_condition;
        this->end_condition = end_condition;
        this->block = block;
        this->id = id;
    }
    std::string getId() {
        return this->id;
    }
    ASTExpression * getInit_condition() {
        return this->init_condition;
    }
    ASTExpression * getEnd_condition() {
        return this->end_condition;
    }
    ASTBlockStatement * getBlock() {
        return this->block;
    }
    ~ASTForStatement() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTReturnStatement : public ASTStatement
{
    ASTExpression * expr;
    public:
    ASTReturnStatement(ASTExpression * expr) {
        this->expr = expr;
    }
    ASTExpression * getExpr() {
        return this->expr;
    }
    ~ASTReturnStatement() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTContinueStatement : public ASTStatement
{
    public:
        ASTContinueStatement() {

        }
        ~ASTContinueStatement() {

        }
        void accept(Visitor * v) {
            v->visit(this);
        }
};

class ASTBreakStatement : public ASTStatement
{
    public:
        ASTBreakStatement() {

        }
        ~ASTBreakStatement() {

        }
        void accept(Visitor * v) {
            v->visit(this);
        }
};

class ASTLocation : public ASTExpression
{
    public:
        ASTLocation() {

        }
        ~ASTLocation() {

        }
        void accept(Visitor * v) = 0;
};

class ASTVarLocation : public ASTLocation 
{
    std::string id;
    public:
    ASTVarLocation(std::string id) {
        this->id = id;
    }
    std::string getId() {
        return this->id;
    }
    ~ASTVarLocation() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTArrayLocation : public ASTLocation
{
    std::string id;
    ASTExpression * index;
    public:
    ASTArrayLocation(std::string id, ASTExpression * index) {
        this->id = id;
        this->index = index;
    }
    std::string getId() {
        return this->id;
    }
    ASTExpression * getIndex() {
        return this->index;
    }
    ~ASTArrayLocation() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTLiteralExpression : public ASTExpression
{
    public:
        ASTLiteralExpression() {

        }
        ~ASTLiteralExpression() {

        }
        virtual void accept(Visitor * v) = 0;
};

class ASTIntegerLiteralExpression : public ASTLiteralExpression
{
    int value;
    public:
    ASTIntegerLiteralExpression(int value) {
        this->value = value;
    }
    int getValue() {
        return this->value;
    }
    ~ASTIntegerLiteralExpression() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTCharLiteralExpression : public ASTLiteralExpression
{
    char value;
    public:
    ASTCharLiteralExpression(char value) {
        this->value = value;
    }
    char getValue() {
        return this->value;
    }
    ~ASTCharLiteralExpression() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTTrueLiteralExpression : public ASTLiteralExpression
{
    public:
        ASTTrueLiteralExpression() {

        }
        bool getValue() {
            return true;
        }
        ~ASTTrueLiteralExpression() {

        }
        void accept(Visitor * v) {
            v->visit(this);
        }
};

class ASTFalseLiteralExpression : public ASTLiteralExpression
{
    public:
        ASTFalseLiteralExpression() {

        }
        bool getValue() {
            return false;
        }
        ~ASTFalseLiteralExpression() {

        }
        void accept(Visitor * v) {
            v->visit(this);
        }
};

class ASTBinaryOperationExpression : public ASTExpression
{
    ASTExpression * left;
    ASTExpression * right;
    BinOp op;
    public:
    ASTBinaryOperationExpression(ASTExpression * left, ASTExpression * right, BinOp op) {
        this->left = left;
        this->right = right;
        this->op = op;
    }
    ASTExpression * getLeft() {
        return this->left;
    }
    ASTExpression * getRight() {
        return this->right;
    }
    BinOp getOp() {
        return this->op;
    }
    ~ASTBinaryOperationExpression() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTUnaryOperationExpression : public ASTExpression
{
    ASTExpression * expr;
    UnOp op;
    public:
    ASTUnaryOperationExpression(ASTExpression * expr, UnOp op) {
        this->expr = expr;
        this->op = op;
    }
    ASTExpression * getExpr() {
        return this->expr;
    }
    UnOp getOp () {
        return this->op;
    }
    ~ASTUnaryOperationExpression() {

    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class PrintVisitor : public Visitor
{
public:
    void visit(ASTProgram * node) {
        outfile<<"<program>"<<std::endl;
        if(node->getFdl() == NULL){
            outfile<<"<field_declarations count = \"0\">"<<std::endl;
        }

        else{
            outfile<<"<field_declarations count =\" "<<(node->getFdl())->size()<<"\">"<<std::endl;
            for(auto it = (node->getFdl())->begin() ; it != (node->getFdl())->end(); it++) {
                (*it)->accept(this);
            }               
        }
        outfile<<"</field_declarations>"<<std::endl;
        if(node->getMdl() == NULL){
            outfile<<"<method_declarations count = \"0\">"<<std::endl;
        }

        else{
            outfile<<"<method_declarations count =\" "<<(node->getMdl())->size()<<"\">"<<std::endl;
            for(auto it = (node->getMdl())->begin() ; it != (node->getMdl())->end(); it++) {
                (*it)->accept(this);
            }               
        }
        outfile<<"</method_declarations>"<<std::endl;
        outfile<<"</program>"<<std::endl;
    }
    void visit(ASTFieldDecl * node) {
        outfile<< "<declarations type=" << node->parseDatatype(node->getType())<<">"<<std::endl;
        if (node->getVar_id_list()) {
            for(auto it = (node->getVar_id_list())->begin() ; it != (node->getVar_id_list())->end(); it++) {
                (*it)->accept(this);
            }   
        }
        if (node->getArray_id_list()) {
            for(auto it = (node->getArray_id_list())->begin() ; it != (node->getArray_id_list())->end(); it++) {
                (*it)->accept(this);
            }
        }
        outfile << "</declarations>"<<std::endl;
    }

    void visit(ASTVarIdentifier * node) {
        outfile<<"<name="<<node->getId() << "/>"<<std::endl;
    }

    void visit(ASTArrayIdentifier * node) {
        outfile<<"<name="<<node->getId()<<" size="<<node->getSize()<<" />"<<std::endl;
    }

    void visit(ASTMethodDecl * node) {
        outfile<<node->parseDatatype(node->getReturnType())<<" "<<node->getId()<<" ";
        outfile<<"(";
        if (node->getArguments()) {
            for(auto it = (node->getArguments())->begin() ; it != (node->getArguments())->end(); it++) {
                (*it)->accept(this);
            }
        }
        outfile<<")"<<std::endl;
        /* Block statement is called*/
        node->getBlock()->accept(this);
    }
    void visit(ASTTypeIdentifier * node) {
        outfile<<node->parseDatatype(node->getType())<<" "<<node->getId()<<" ";
    }

    void visit(ASTBlockStatement * node) {
        outfile<<"{"<<std::endl;
        outfile<<"no of statements = ";
        if(node->getStmtlist() && node->getId_list()){
            outfile<<node->getStmtlist()->size() + node->getId_list()->size()<<std::endl;
        for(auto it = (node->getId_list())->begin() ; it != (node->getId_list())->end(); it++) {
            (*it)->accept(this);
        }
        for(auto it = (node->getStmtlist())->begin() ; it != (node->getStmtlist())->end(); it++) {
            (*it)->accept(this);
        }
        }
        else if(node->getStmtlist()){
            outfile<<node->getStmtlist()->size()<<std::endl;
            for(auto it = (node->getStmtlist())->begin() ; it != (node->getStmtlist())->end(); it++) {
            (*it)->accept(this);
        }
        }
        else if(node->getId_list()){
            outfile<<node->getId_list()->size()<<std::endl;
            for(auto it = (node->getId_list())->begin() ; it != (node->getId_list())->end(); it++) {
            (*it)->accept(this);
        }
        }
        
        outfile<<std::endl;
        
        outfile<<"}"<<std::endl;
    }

    void visit(ASTAssignmentStatement * node) {
        node->getLocation()->accept(this);
        outfile<<" "<<node->parseAssignOp(node->getOp())<<" ";
        node->getExpr()->accept(this);
        outfile<<std::endl;
    }
    void visit(ASTMethodCall * node) {
        outfile<<""<<std::endl;
    }
    void visit(ASTNormalMethod * node) {
        outfile<<node->getId()<<"(";
        if(node->getArguments()){
            for(auto it = (node->getArguments())->begin() ; it != (node->getArguments())->end(); it++) {
              (*it)->accept(this);
            }
        }
        outfile<<")";
    }
    void visit(ASTCalloutMethod * node) {
        outfile<<"<callout function=\""<<node->getMethod_name()<<"\">";
        if(node->getArguments()){
            for(auto it = (node->getArguments())->begin() ; it != (node->getArguments())->end(); it++) {
              (*it)->accept(this);
            }
        }
        outfile<<"</callout>"<<std::endl;
    }
    void visit(ASTCalloutArg * node) {
        
    }
    void visit(ASTStringCalloutArg * node) {
        outfile<<node->getArgument();
    }
    void visit(ASTExpressionCalloutArg * node) {
        node->getArgument()->accept(this);
    }
    void visit(ASTIfStatement * node) {
        outfile<<"if(";
        node->getCondition()->accept(this);
        outfile<<")"<<std::endl;
        node->getIf_block()->accept(this);
        if(node->getElse_block())
            node->getElse_block()->accept(this);
    }
    void visit(ASTForStatement * node) {
        node->getInit_condition()->accept(this);
        node->getEnd_condition()->accept(this);
        node->getBlock()->accept(this);

    }
    void visit(ASTReturnStatement * node) {
        outfile<<"return ";
        node->getExpr()->accept(this);
    }
    void visit(ASTContinueStatement * node) {
        outfile<<"continue"<<std::endl;
    }
    void visit(ASTBreakStatement * node) {
        outfile<<"break"<<std::endl;
    }
    void visit(ASTLocation * node) {
        outfile<<""<<std::endl;
    }
    void visit(ASTVarLocation * node) {
        outfile<<node->getId()<<" ";
    }
    void visit(ASTArrayLocation * node) {
        outfile<<node->getId()<<" ["<<node->getIndex()<<"]";
    }
    void visit(ASTLiteralExpression * node) {
        outfile<<""<<std::endl;
    }
    void visit(ASTIntegerLiteralExpression * node) {
        outfile<<"<integer value="<<node->getValue()<<" />"<<std::endl;
    }
    void visit(ASTCharLiteralExpression * node) {
        outfile<<"<character value="<<node->getValue()<<" />"<<std::endl;
    }
    void visit(ASTTrueLiteralExpression * node) {
        outfile<<"<boolean value="<<node->getValue()<<" />"<<std::endl;
    }
    void visit(ASTFalseLiteralExpression * node) {
        outfile<<"<boolean value="<<node->getValue()<<" />"<<std::endl;
    }
    void visit(ASTBinaryOperationExpression * node) {
    	outfile<<"<binary_expression type=\"" <<node->parseBinOp(node->getOp())<< "\">";
        node->getLeft()->accept(this);
        node->getRight()->accept(this);
        outfile<<"</binary_expression>";
    }
    void visit(ASTUnaryOperationExpression * node) {
        outfile<<node->parseUnOp(node->getOp())<<" "<<std::endl;
        node->getExpr()->accept(this);
    }
    void visit(ASTVarDecl * node) {
        outfile<<node->parseDatatype(node->getType())<<" ";
        for(auto it = (node->getId_list())->begin() ; it != (node->getId_list())->end(); it++) {
              (*it)->accept(this);
            }
        outfile<<std::endl;
    }
    void visit(ASTIdentifier * node) {
        outfile<<""<<std::endl;
    }
    void visit(ASTStatement * node) {
        outfile<<""<<std::endl;
    }
    void visit(ASTExpression * node) {
        outfile<<""<<std::endl;
    }
};

#endif