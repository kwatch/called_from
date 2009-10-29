/**
 ** $Release: $
 ** $Copyright$
 ** $License$
 **/

#include <ruby.h>
#include <env.h>    /* contains definition of struct FRAME */
#include <node.h>   /* contains definition of struct RNode */
#include <assert.h>


/**
 *  get location information of caller().
 *
 *  @param level same as argument of caller()
 *  @return array of filename, line number, and function name
 */
static VALUE
rb_f_called_from(argc, argv)
    int argc;
    VALUE *argv;
{
    VALUE level;
    int lev;
    struct FRAME *frame;
    const char *func_name;

    /* check argument */
    rb_scan_args(argc, argv, "01", &level);
    lev = NIL_P(level) ? 1 : NUM2INT(level);
    if (lev < 0) rb_raise(rb_eArgError, "negative level (%d)", lev);

    /* get frame */
    frame = ruby_frame;
    if (! frame) return Qnil;
    if (frame->last_func == ID_ALLOCATOR) {
        frame = frame->prev;
        if (! frame) return Qnil;
    }

    /* traverse frame */
    while (lev--) {
        if (! frame->prev) return Qnil;
        frame = frame->prev;
    }
    assert(frame != NULL);

    /* if node is not found then return nil */
    if (! frame->node) return Qnil;

    /* function name */
    func_name = frame->prev && frame->prev->last_func
              ? rb_id2name(frame->prev->last_func)
              : NULL;

    /* return [ filename, line number, function name ] */
   return rb_ary_new3(3, rb_str_new2(frame->node->nd_file),
                         INT2NUM(nd_line(frame->node)),
                         func_name ? rb_str_new2(func_name) : Qnil);
}


void Init_called_from(void) {
    /* register called_from() as global function */
    rb_define_global_function("called_from", rb_f_called_from, -1);
}
