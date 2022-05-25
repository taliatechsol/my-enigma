import { Body, Controller, Post } from '@nestjs/common';
import { response } from 'src/interfaces/response.interface';
import { users } from 'src/interfaces/user.interface';
import { UserService } from 'src/services/user/user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  async createUser(@Body() users: users): Promise<response> {
    try{
      const validateUser = await this.userService.validateUser(users);
      if(validateUser == true) {
        const createUsr = await this.userService.createUser(users);
        if (createUsr.userName === users.userName ) {
          return {
            status: 200,
            message: 'Success',
            data: createUsr,
          };
        } else {
          return {
            status: 500,
            message: 'Fail',
            data: 'User Cannot be Created !!!!!',
          };
        }
      } else {
        return {
          status: 409,
          message: 'Fail',
          data: 'User already Created !!!!!',
        };
      }
    } catch(err){
      return err;
    }
  }

  @Post('password')
  async createUserPassword(@Body() user : users): Promise<response> {
    try{
      const validateUser = await this.userService.validateUserByID(user);
      if(validateUser == true) {
        const updateUsr = await this.userService.updatePassword(user);
        if (updateUsr == true) {
          return {
            status : 200,
            message : "Success",
            data : "Password Updated Successfully !!!"
          }
        } else {
          return {
            status : 500,
            message : "Fail",
            data : "User Password cannot be updated !!!!"
          }
        }
      } else {
        return {
          status : 409,
          message : "Fail",
          data : "User Not Found !!!!"
        }
      }
    } catch(err) {
      return err;
    }
  }

  @Post('OTP')
  async generateOTP(@Body() user: users): Promise<response> {
    const otp = this.userService.generateOTP(user);
    if ((await otp) != null) {
      return {
        status: 200,
        message: 'Success',
        data: otp,
      };
    } else {
      return {
        status: 500,
        message: 'Fail',
        data: 'OTP Cannot be Generated !!!!!',
      };
    }
  }

  @Post('validate')
  async validateOTP(@Body() user: users): Promise<response> {
    const validate = this.userService.validateOTP(user);
    if ((await validate) == true) {
      return {
        status: 200,
        message: 'Success',
        data: 'OTP Verified Successfully !!!!!',
      };
    } else {
      return {
        status: 500,
        message: 'Fail',
        data: 'OTP Cannot be Verified !!!!!',
      };
    }
  }
}
